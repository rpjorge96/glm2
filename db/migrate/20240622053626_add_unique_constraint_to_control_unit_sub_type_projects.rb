class AddUniqueConstraintToControlUnitSubTypeProjects < ActiveRecord::Migration[7.1]
  def change
    add_index :control_unit_sub_type_projects, [:project_id, :control_unit_sub_type_id], unique: true, name: "unique_project_and_control_unit_sub_type"
  end
end
