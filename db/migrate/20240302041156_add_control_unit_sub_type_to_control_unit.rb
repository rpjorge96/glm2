class AddControlUnitSubTypeToControlUnit < ActiveRecord::Migration[7.1]
  def change
    add_reference :control_units, :control_unit_sub_type, null: true, foreign_key: true
  end
end
