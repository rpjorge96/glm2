require "rails_helper"

RSpec.describe "boundaries/index", type: :view do
  before(:each) do
    assign(:boundaries, [
      Boundary.create!(
        station: 2,
        observed_point: 3,
        azimuth: "Azimuth",
        distance: 4.5,
        neighbor: "Neighbor",
        control_units: nil
      ),
      Boundary.create!(
        station: 2,
        observed_point: 3,
        azimuth: "Azimuth",
        distance: 4.5,
        neighbor: "Neighbor",
        control_units: nil
      )
    ])
  end

  it "renders a list of boundaries" do
    render
    cell_selector = (Rails::VERSION::STRING >= "7") ? "div>p" : "tr>td"
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(3.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Azimuth"), count: 2
    assert_select cell_selector, text: Regexp.new(4.5.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Neighbor"), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
