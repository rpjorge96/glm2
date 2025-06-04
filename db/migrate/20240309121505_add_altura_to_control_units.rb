class AddAlturaToControlUnits < ActiveRecord::Migration[7.1]
  def change
    add_column :control_units, :altura, :string
  end
end
