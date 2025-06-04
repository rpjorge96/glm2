class RemoveControlUnitSubTypeForeignKeyFromControlUnits < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :control_units, :control_unit_sub_types
  end
end
