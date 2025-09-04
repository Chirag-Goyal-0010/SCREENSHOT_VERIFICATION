require 'rails_helper'

RSpec.describe "Images", type: :request do

  let!(:reference_image) do
    ref = ReferenceImage.create!(title: "Ref Post")
    ref.file.attach(io: File.open(Rails.root.join("spec/fixtures/files/ref.jpg")), filename: "ref.jpg", content_type: "image/jpg")
    ref
  end

  describe "POST /images" do
    it "uploads screenshot and links to reference" do
      post images_path, params: {
        image: {
          title: "User Screenshot",
          description: "Test case",
          reference_image_id: reference_image.id,
          file: fixture_file_upload("ss.jpg", "image/jpg")  # corrected path; removed 'files/'
        }
      }
      follow_redirect!

      img = Image.last
      expect(img.reference_image).to eq(reference_image)
      expect(img.phash_result).not_to be_nil
      expect(response.body).to include("Similarity")
      expect(response.body).to include("Decision")
    end
  end

end
