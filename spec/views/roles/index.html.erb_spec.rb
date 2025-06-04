require "rails_helper"

RSpec.describe "roles/index", type: :view do
  before(:each) do
    assign(:roles, [
      Role.create!(
        name: "Name"
      ),
      Role.create!(
        name: "Name"
      )
    ])
  end

  it "renders a list of roles" do
    render
    cell_selector = (Rails::VERSION::STRING >= "7") ? "div>p" : "tr>td"
    assert_select cell_selector, text: Regexp.new("Name"), count: 2
  end
end
