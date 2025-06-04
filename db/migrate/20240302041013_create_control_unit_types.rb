class CreateControlUnitTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :control_unit_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
