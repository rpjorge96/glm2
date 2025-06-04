require "rails_helper"

RSpec.describe "boundaries/new", type: :view do
  before(:each) do
    assign(:boundary, Boundary.new(
      station: 1,
      observed_point: 1,
      azimuth: "MyString",
      distance: 1.5,
      neighbor: "MyString",
      control_units: nil
    ))
  end

  it "renders new boundary form" do
    render

    assert_select "form[action=?][method=?]", boundaries_path, "post" do
      assert_select "input[name=?]", "boundary[station]"

      assert_select "input[name=?]", "boundary[observed_point]"

      assert_select "input[name=?]", "boundary[azimuth]"

      assert_select "input[name=?]", "boundary[distance]"

      assert_select "input[name=?]", "boundary[neighbor]"

      assert_select "input[name=?]", "boundary[control_units_id]"
    end
  end
end
