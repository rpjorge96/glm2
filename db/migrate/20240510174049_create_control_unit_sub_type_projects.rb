class CreateControlUnitSubTypeProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :control_unit_sub_type_projects do |t|
      t.references :project, null: false, foreign_key: true
      t.references :control_unit_sub_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
