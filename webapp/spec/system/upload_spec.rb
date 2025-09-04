require 'rails_helper'

RSpec.describe "Image Upload Flow", type: :system do
  before do
    driven_by(:rack_test)
  end

  it "allows user to upload an image" do
    visit new_image_path

    attach_file "Upload Image", Rails.root.join("spec/fixtures/files/test.png")
    fill_in "Title", with: "My Screenshot"
    fill_in "Description", with: "Test upload"
    click_button "Save Image"   # matches the updated form submit text

    expect(page).to have_content("Image was successfully created.")
    expect(Image.last.file).to be_attached
  end
end
