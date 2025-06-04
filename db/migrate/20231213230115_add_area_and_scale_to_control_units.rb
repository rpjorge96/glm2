class AddAreaAndScaleToControlUnits < ActiveRecord::Migration[7.1]
  def change
    add_column :control_units, :area, :decimal, precision: 10, scale: 2
    add_column :control_units, :scale, :string
  end
end
