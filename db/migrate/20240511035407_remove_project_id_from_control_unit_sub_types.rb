class RemoveProjectIdFromControlUnitSubTypes < ActiveRecord::Migration[7.1]
  def up
    remove_index :control_unit_sub_types, name: "idx_on_control_unit_type_id_project_id_name_bb4e9ea4ea"
    remove_column :control_unit_sub_types, :project_id
  end

  def down
    add_column :control_unit_sub_types, :project_id, :bigint, null: false
    add_index :control_unit_sub_types, [:control_unit_type_id, :project_id, :name], unique: true, name: "idx_on_control_unit_type_id_project_id_name_bb4e9ea4ea"
  end
end
