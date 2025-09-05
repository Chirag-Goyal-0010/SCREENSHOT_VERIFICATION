class Image < ApplicationRecord
  has_one_attached :file
  belongs_to :reference_image, optional: true

  has_one :phash_result, dependent: :destroy

  # New columns for Sprint 3
  # t.float :vgg16_similarity
  # t.string :vgg16_decision

  # After creating image, run pHash analysis
  after_commit :run_phash_analysis, on: :create

  private

  def run_phash_analysis
    return unless file.attached? && reference_image&.file&.attached?

    begin
      # Absolute paths for uploaded files (for pHash service)
      screenshot_path = ActiveStorage::Blob.service.send(:path_for, file.key)
      reference_path  = ActiveStorage::Blob.service.send(:path_for, reference_image.file.key)

      # Call Python pHash service
      response = PhashClient.compare(screenshot_path, reference_path)
      data = JSON.parse(response.body)

      # Store pHash result
      phash = PhashResult.create!(
        image: self,
        similarity: data["similarity"],
        decision: data["decision"]
      )

      # Trigger VGG16 analysis if borderline
      run_vgg16_analysis if phash.decision == "borderline"
    rescue => e
      Rails.logger.error "❌ pHash analysis failed for Image ##{id}: #{e.message}"
    end
  end

  def run_vgg16_analysis
    return unless file.attached? && reference_image&.file&.attached?

    begin
      require "net/http"
      require "json"
      require "net/http/post/multipart" # gem 'multipart-post'
      require "tempfile"

      # Download ActiveStorage files to temp files
      tmp_screenshot = Tempfile.new(['screenshot', '.jpg'])
      tmp_reference  = Tempfile.new(['reference', '.jpg'])

      tmp_screenshot.binmode
      tmp_screenshot.write(file.download)
      tmp_screenshot.rewind

      tmp_reference.binmode
      tmp_reference.write(reference_image.file.download)
      tmp_reference.rewind

      # ngrok URL for Flask VGG16 API
      ngrok_url = ENV["VGG16_BASE_URL"] || "http://localhost:5002/vgg16"
      uri = URI.parse(ngrok_url)

      request = Net::HTTP::Post::Multipart.new(
        uri.path,
        "image1" => UploadIO.new(tmp_screenshot, 'image/jpeg', 'screenshot.jpg'),
        "image2" => UploadIO.new(tmp_reference, 'image/jpeg', 'reference.jpg')
      )

      response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
        http.request(request)
      end

      data = JSON.parse(response.body)

      # Update Image with VGG16 result
      update!(
        vgg16_similarity: data["similarity"],
        vgg16_decision: data["decision"]
      )
    rescue => e
      Rails.logger.error "❌ VGG16 analysis failed for Image ##{id}: #{e.message}"
    ensure
      # Cleanup temp files
      tmp_screenshot.close! if tmp_screenshot
      tmp_reference.close!  if tmp_reference
    end
  end
end
