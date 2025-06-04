class AddNewAttributesToControlUnitSubTypes < ActiveRecord::Migration[7.1]
  def change
    add_column :control_unit_sub_types, :garden_area, :integer
    add_column :control_unit_sub_types, :balconies_terrace_area, :integer
    add_column :control_unit_sub_types, :parking_spaces, :integer
    add_column :control_unit_sub_types, :parking_type, :string
    add_column :control_unit_sub_types, :subtype_variable_data, :jsonb, default: {}
  end
end
