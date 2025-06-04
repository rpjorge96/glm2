require "rails_helper"

RSpec.describe "boundaries/show", type: :view do
  before(:each) do
    assign(:boundary, Boundary.create!(
      station: 2,
      observed_point: 3,
      azimuth: "Azimuth",
      distance: 4.5,
      neighbor: "Neighbor",
      control_units: nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/Azimuth/)
    expect(rendered).to match(/4.5/)
    expect(rendered).to match(/Neighbor/)
    expect(rendered).to match(//)
  end
end
