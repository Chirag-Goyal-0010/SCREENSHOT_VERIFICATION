require 'rails_helper'

RSpec.describe "reference_images/edit", type: :view do
  let(:reference_image) {
    ReferenceImage.create!(
      title: "MyString",
      description: "MyText"
    )
  }

  before(:each) do
    assign(:reference_image, reference_image)
  end

  it "renders the edit reference_image form" do
    render

    assert_select "form[action=?][method=?]", reference_image_path(reference_image), "post" do

      assert_select "input[name=?]", "reference_image[title]"

      assert_select "textarea[name=?]", "reference_image[description]"
    end
  end
end
