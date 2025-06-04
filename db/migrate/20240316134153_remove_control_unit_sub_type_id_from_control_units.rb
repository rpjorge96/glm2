class RemoveControlUnitSubTypeIdFromControlUnits < ActiveRecord::Migration[7.1]
  def change
    remove_column :control_units, :control_unit_sub_type_id, :integer
  end
end
