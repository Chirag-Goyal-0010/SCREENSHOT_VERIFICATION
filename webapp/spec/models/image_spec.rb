require 'rails_helper'

RSpec.describe Image, type: :model do
  it 'can attach a file' do
    image = Image.create!(title: "Test", description: "Demo")
    file = fixture_file_upload(Rails.root.join("spec/fixtures/files/test.png"), "image/png")
    image.file.attach(file)

    expect(image.file).to be_attached
  end
end
