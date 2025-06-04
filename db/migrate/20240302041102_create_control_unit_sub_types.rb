class CreateControlUnitSubTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :control_unit_sub_types do |t|
      t.string :name
      t.references :control_unit_type, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
    add_index :control_unit_sub_types, [:control_unit_type_id, :project_id, :name], unique: true
  end
end
