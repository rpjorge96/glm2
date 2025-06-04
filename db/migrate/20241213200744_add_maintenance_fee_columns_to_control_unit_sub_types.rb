class AddMaintenanceFeeColumnsToControlUnitSubTypes < ActiveRecord::Migration[7.1]
  def change
    add_column :control_unit_sub_types, :active_maintenance_fee_dollars, :decimal
    add_column :control_unit_sub_types, :passive_maintenance_fee_dollars, :decimal
  end
end
