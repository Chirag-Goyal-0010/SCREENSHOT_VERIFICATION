require 'rails_helper'

RSpec.describe "reference_images/new", type: :view do
  before(:each) do
    assign(:reference_image, ReferenceImage.new(
      title: "MyString",
      description: "MyText"
    ))
  end

  it "renders new reference_image form" do
    render

    assert_select "form[action=?][method=?]", reference_images_path, "post" do

      assert_select "input[name=?]", "reference_image[title]"

      assert_select "textarea[name=?]", "reference_image[description]"
    end
  end
end
