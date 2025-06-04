class RemoveFieldsFromControlUnitSubTypes < ActiveRecord::Migration[7.1]
  def change
    remove_column :control_unit_sub_types, :construction_area, :decimal
    remove_column :control_unit_sub_types, :garden_balcony_area, :decimal
    remove_column :control_unit_sub_types, :laundry_area, :decimal
    remove_column :control_unit_sub_types, :pergola_area, :decimal
    remove_column :control_unit_sub_types, :terrace_area, :decimal
    remove_column :control_unit_sub_types, :kitchen, :boolean
    remove_column :control_unit_sub_types, :laundry, :boolean
    remove_column :control_unit_sub_types, :rooms, :integer
    remove_column :control_unit_sub_types, :bathrooms, :decimal
    remove_column :control_unit_sub_types, :parking_spaces, :integer
    remove_column :control_unit_sub_types, :floors, :integer
    remove_column :control_unit_sub_types, :living_dining_room, :boolean
  end
end
