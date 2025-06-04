require "rails_helper"

RSpec.describe "control_units/new", type: :view do
  before(:each) do
    assign(:control_unit, ControlUnit.new(
      project: nil,
      code: "MyString",
      description: "MyText",
      control_unit_type: 1,
      zero_point_location: "MyString",
      finca_number: 1,
      folio_number: 1,
      book_number: 1,
      where_is_the_book_from: "MyString",
      string: "MyString",
      ccc_number: 1,
      coordinates: "MyString",
      predio_number: 1
    ))
  end

  it "renders new control_unit form" do
    render

    assert_select "form[action=?][method=?]", project_control_units_path, "post" do
      assert_select "input[name=?]", "control_unit[project_id]"

      assert_select "input[name=?]", "control_unit[code]"

      assert_select "textarea[name=?]", "control_unit[description]"

      assert_select "input[name=?]", "control_unit[control_unit_type]"

      assert_select "input[name=?]", "control_unit[zero_point_location]"

      assert_select "input[name=?]", "control_unit[finca_number]"

      assert_select "input[name=?]", "control_unit[folio_number]"

      assert_select "input[name=?]", "control_unit[book_number]"

      assert_select "input[name=?]", "control_unit[where_is_the_book_from]"

      assert_select "input[name=?]", "control_unit[string]"

      assert_select "input[name=?]", "control_unit[ccc_number]"

      assert_select "input[name=?]", "control_unit[coordinates]"

      assert_select "input[name=?]", "control_unit[predio_number]"
    end
  end
end
