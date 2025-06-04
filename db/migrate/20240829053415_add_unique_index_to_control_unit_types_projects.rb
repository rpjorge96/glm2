class AddUniqueIndexToControlUnitTypesProjects < ActiveRecord::Migration[7.1]
  def up
    add_index :control_unit_types_projects, [:control_unit_type_id, :project_id], unique: true, name: "index_control_unit_type_project_uniqueness"
  end

  def down
    remove_index :control_unit_types_projects, name: "index_control_unit_type_project_uniqueness"
  end
end
