class Image < ApplicationRecord
  has_one_attached :file
  belongs_to :reference_image, optional: true

  has_one :phash_result, dependent: :destroy

  after_commit :run_phash_analysis, on: :create

  private

  def run_phash_analysis
    return unless file.attached? && reference_image&.file&.attached?

    begin
      # Get absolute paths for both uploaded screenshot and reference image
      screenshot_path = ActiveStorage::Blob.service.send(:path_for, file.key)
      reference_path  = ActiveStorage::Blob.service.send(:path_for, reference_image.file.key)

      # Send request to Python pHash service
      response = PhashClient.compare(screenshot_path, reference_path)
      data = JSON.parse(response.body)

      # Store result
      PhashResult.create!(
        image: self,
        similarity: data["similarity"],
        decision: data["decision"]
      )
    rescue => e
      Rails.logger.error "❌ pHash analysis failed for Image ##{id}: #{e.message}"
    end
  end
end
