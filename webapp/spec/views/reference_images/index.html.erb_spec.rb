require 'rails_helper'

RSpec.describe "reference_images/index", type: :view do
  before(:each) do
    assign(:reference_images, [
      ReferenceImage.create!(
        title: "Title",
        description: "MyText"
      ),
      ReferenceImage.create!(
        title: "Title",
        description: "MyText"
      )
    ])
  end

  it "renders a list of reference_images" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Title".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
  end
end
