class ChangeGardenAndBalconiesTerraceToDecimal < ActiveRecord::Migration[7.1]
  def up
    change_column :control_unit_sub_types,
      :garden_area,
      :decimal,
      precision: 10,
      scale: 2
    change_column :control_unit_sub_types,
      :balconies_terrace_area,
      :decimal,
      precision: 10,
      scale: 2
  end

  def down
    change_column :control_unit_sub_types, :garden_area, :integer
    change_column :control_unit_sub_types, :balconies_terrace_area, :integer
  end
end
