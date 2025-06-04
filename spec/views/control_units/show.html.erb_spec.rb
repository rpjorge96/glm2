require "rails_helper"

RSpec.describe "control_units/show", type: :view do
  before(:each) do
    assign(:control_unit, ControlUnit.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Code/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Zero Point Location/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(/5/)
    expect(rendered).to match(/Where Is The Book From/)
    expect(rendered).to match(/String/)
    expect(rendered).to match(/6/)
    expect(rendered).to match(/Coordinates/)
    expect(rendered).to match(/7/)
  end
end
