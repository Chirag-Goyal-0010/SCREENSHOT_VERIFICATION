require 'rails_helper'

RSpec.describe PhashClient do
  it "returns similarity and decision" do
    img_path = Rails.root.join("spec/fixtures/files/test.png")
    ref_path = Rails.root.join("spec/fixtures/files/reference.png")

    response = PhashClient.compare(img_path, ref_path)
    data = JSON.parse(response.body)

    expect(data).to include("similarity", "decision")
    expect(%w[accept reject borderline]).to include(data["decision"])
  end
end
