class CreateControlUnitTypesProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :control_unit_types_projects do |t|
      t.references :control_unit_type, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
