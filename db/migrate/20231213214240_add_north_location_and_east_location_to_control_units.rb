class AddNorthLocationAndEastLocationToControlUnits < ActiveRecord::Migration[7.1]
  def change
    add_column :control_units, :north_location, :string
    add_column :control_units, :east_location, :string
  end
end
