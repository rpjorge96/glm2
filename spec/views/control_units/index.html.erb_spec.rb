require "rails_helper"

RSpec.describe "control_units/index", type: :view do
  before(:each) do
    assign(:control_units, [
      ControlUnit.create!(
        project: nil,
        code: "Code",
        description: "MyText",
        control_unit_type: 2,
        zero_point_location: "Zero Point Location",
        finca_number: 3,
        folio_number: 4,
        book_number: 5,
        where_is_the_book_from: "Where Is The Book From",
        string: "String",
        ccc_number: 6,
        coordinates: "Coordinates",
        predio_number: 7
      ),
      ControlUnit.create!(
        project: nil,
        code: "Code",
        description: "MyText",
        control_unit_type: 2,
        zero_point_location: "Zero Point Location",
        finca_number: 3,
        folio_number: 4,
        book_number: 5,
        where_is_the_book_from: "Where Is The Book From",
        string: "String",
        ccc_number: 6,
        coordinates: "Coordinates",
        predio_number: 7
      )
    ])
  end

  it "renders a list of control_units" do
    render
    cell_selector = (Rails::VERSION::STRING >= "7") ? "div>p" : "tr>td"
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Code"), count: 2
    assert_select cell_selector, text: Regexp.new("MyText"), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Zero Point Location"), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(4.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(5.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Where Is The Book From"), count: 2
    assert_select cell_selector, text: Regexp.new("String"), count: 2
    assert_select cell_selector, text: Regexp.new(6.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Coordinates"), count: 2
    assert_select cell_selector, text: Regexp.new(7.to_s), count: 2
  end
end
