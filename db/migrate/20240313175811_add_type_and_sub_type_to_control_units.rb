class AddTypeAndSubTypeToControlUnits < ActiveRecord::Migration[7.1]
  def change
    change_column :control_units, :control_unit_type, :string
    add_column :control_units, :control_unit_sub_type, :string
  end
end
