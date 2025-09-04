require 'rails_helper'

RSpec.describe "reference_images/show", type: :view do
  before(:each) do
    assign(:reference_image, ReferenceImage.create!(
      title: "Title",
      description: "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
  end
end
