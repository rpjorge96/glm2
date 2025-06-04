require "rails_helper"

RSpec.describe "projects/index", type: :view do
  before(:each) do
    assign(:projects, [
      Project.create!(
        name: "Name",
        description: "Description"
      ),
      Project.create!(
        name: "Name",
        description: "Description"
      )
    ])
  end

  it "renders a list of projects" do
    render
    cell_selector = (Rails::VERSION::STRING >= "7") ? "div>p" : "tr>td"
    assert_select cell_selector, text: Regexp.new("Name"), count: 2
    assert_select cell_selector, text: Regexp.new("Description"), count: 2
  end
end
