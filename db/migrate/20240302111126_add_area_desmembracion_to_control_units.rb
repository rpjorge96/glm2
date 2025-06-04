class AddAreaDesmembracionToControlUnits < ActiveRecord::Migration[7.1]
  def change
    add_column :control_units, :area_desmembracion, :float
  end
end
