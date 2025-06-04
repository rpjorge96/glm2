require "rails_helper"

RSpec.describe "boundaries/edit", type: :view do
  let(:boundary) {
    Boundary.create!(
      station: 1,
      observed_point: 1,
      azimuth: "MyString",
      distance: 1.5,
      neighbor: "MyString",
      control_units: nil
    )
  }

  before(:each) do
    assign(:boundary, boundary)
  end

  it "renders the edit boundary form" do
    render

    assert_select "form[action=?][method=?]", boundary_path(boundary), "post" do
      assert_select "input[name=?]", "boundary[station]"

      assert_select "input[name=?]", "boundary[observed_point]"

      assert_select "input[name=?]", "boundary[azimuth]"

      assert_select "input[name=?]", "boundary[distance]"

      assert_select "input[name=?]", "boundary[neighbor]"

      assert_select "input[name=?]", "boundary[control_units_id]"
    end
  end
end
