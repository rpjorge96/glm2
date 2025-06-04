class CreateControlUnitTypesProjectsExtras < ActiveRecord::Migration[7.1]
  def change
    create_table :control_unit_types_projects_extras do |t|
      t.references :control_unit_types_project, null: false, foreign_key: true
      t.references :extra, null: false, foreign_key: true

      t.timestamps
    end

    add_index :control_unit_types_projects_extras, [:control_unit_types_project_id, :extra_id], unique: true, name: "index_cup_on_project_and_extra"
  end
end
