class AddFincaToControlUnits < ActiveRecord::Migration[7.1]
  def change
    add_reference :control_units, :finca, null: true, foreign_key: true
  end
end
