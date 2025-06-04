class AddColorToControlUnitStatuses < ActiveRecord::Migration[7.1]
  def change
    add_column :control_unit_statuses, :color, :string
  end
end
