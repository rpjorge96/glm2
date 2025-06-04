class RemoveCoordinatesAndScaleAndCccFromControlUnits < ActiveRecord::Migration[7.1]
  def change
    remove_column :control_units, :coordinates, :string
    remove_column :control_units, :scale, :string
    remove_column :control_units, :ccc_number, :string
  end
end
