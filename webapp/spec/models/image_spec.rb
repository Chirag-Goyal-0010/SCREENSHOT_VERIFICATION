require 'rails_helper'
require 'webmock/rspec' # for mocking VGG16 API in tests

RSpec.describe Image, type: :model do

  # Stub VGG16 endpoint for tests
  before(:each) do
    WebMock.stub_request(:post, "https://457818c2e881.ngrok-free.app/vgg16")
           .to_return(body: { similarity: 0.82, decision: "accept" }.to_json, status: 200)
  end

  let!(:reference_image) do
    ref = ReferenceImage.create!(title: "Reference")
    ref.file.attach(
      io: File.open(Rails.root.join("spec/fixtures/files/ref.jpg")),
      filename: "ref.jpg",
      content_type: "image/jpg"
    )
    ref
  end

  describe "validations" do
    it "is valid with title, file, and reference image" do
      img = Image.new(title: "Screenshot", reference_image: reference_image)
      img.file.attach(
        io: File.open(Rails.root.join("spec/fixtures/files/ss.jpg")),
        filename: "ss.jpg",
        content_type: "image/jpg"
      )
      expect(img).to be_valid
    end
  end

  describe "pHash analysis" do
    it "triggers pHash analysis after create" do
      img = Image.new(title: "Screenshot", reference_image: reference_image)
      img.file.attach(fixture_file_upload("ss.jpg", "image/jpg"))
      img.save!
      img.reload

      expect(img.phash_result).not_to be_nil
      expect(img.phash_result.similarity).to be_a(Float)
      expect(["accept", "reject", "borderline"]).to include(img.phash_result.decision)
    end
  end

  describe "VGG16 analysis" do
    it "runs VGG16 for borderline pHash images" do
      # Create image with borderline pHash result
      img = Image.new(title: "Screenshot", reference_image: reference_image)
      img.file.attach(fixture_file_upload("ss_borderline.jpg", "image/jpg"))
      img.save!

      # Manually create borderline pHash result
      PhashResult.create!(image: img, similarity: 75.0, decision: "borderline")

      # Trigger VGG16
      img.run_vgg16_analysis
      img.reload

      expect(img.vgg16_similarity).to be_a(Float)
      expect(["accept", "reject", "borderline"]).to include(img.vgg16_decision)
    end
  end
end
