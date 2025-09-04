require 'rails_helper'

RSpec.describe ReferenceImage, type: :model do
  it "is valid with title and file" do
    ref = ReferenceImage.new(title: "Test Ref")
    ref.file.attach(io: File.open(Rails.root.join("spec/fixtures/files/ref.jpg")), filename: "ref.jpg", content_type: "image/jpg")
    expect(ref).to be_valid
  end

  it "is invalid without a title" do
    ref = ReferenceImage.new
    expect(ref).not_to be_valid
  end
end
