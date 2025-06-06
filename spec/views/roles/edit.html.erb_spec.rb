require "rails_helper"

RSpec.describe "roles/edit", type: :view do
  let(:role) {
    Role.create!(
      name: "MyString"
    )
  }

  before(:each) do
    assign(:role, role)
  end

  it "renders the edit role form" do
    render

    assert_select "form[action=?][method=?]", role_path(role), "post" do
      assert_select "input[name=?]", "role[name]"
    end
  end
end
