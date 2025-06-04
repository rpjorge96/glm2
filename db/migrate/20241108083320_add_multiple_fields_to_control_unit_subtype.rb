class AddMultipleFieldsToControlUnitSubtype < ActiveRecord::Migration[7.1]
  def change
    add_column :control_unit_sub_types, :construction_area, :decimal, precision: 10, scale: 2
    add_column :control_unit_sub_types, :garden_balcony_area, :decimal, precision: 10, scale: 2
    add_column :control_unit_sub_types, :terrace_area, :decimal, precision: 10, scale: 2
    add_column :control_unit_sub_types, :laundry_area, :decimal, precision: 10, scale: 2
    add_column :control_unit_sub_types, :pergola_area, :decimal, precision: 10, scale: 2
    add_column :control_unit_sub_types, :rooms, :integer
    add_column :control_unit_sub_types, :bathrooms, :integer
    add_column :control_unit_sub_types, :parking_spaces, :integer
    add_column :control_unit_sub_types, :floors, :integer
    add_column :control_unit_sub_types, :living_dining_room, :boolean
    add_column :control_unit_sub_types, :kitchen, :boolean
    add_column :control_unit_sub_types, :laundry, :boolean
    add_column :control_unit_sub_types, :passive_maintenance_fee_cents, :integer
    add_column :control_unit_sub_types, :active_maintenance_fee_cents, :integer
    add_column :control_unit_sub_types, :passive_maintenance_fee_currency, :string
    add_column :control_unit_sub_types, :active_maintenance_fee_currency, :string
  end
end
