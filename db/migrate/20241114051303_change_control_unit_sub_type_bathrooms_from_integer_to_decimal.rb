class ChangeControlUnitSubTypeBathroomsFromIntegerToDecimal < ActiveRecord::Migration[7.1]
  def change
    change_column :control_unit_sub_types, :bathrooms, :decimal, precision: 5, scale: 2
  end
end
