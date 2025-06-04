class CreateControlUnitStatuses < ActiveRecord::Migration[7.1]
  def change
    create_table :control_unit_statuses do |t|
      t.string :name

      t.timestamps
    end
  end
end
