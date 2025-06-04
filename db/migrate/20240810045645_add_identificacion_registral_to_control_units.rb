class AddIdentificacionRegistralToControlUnits < ActiveRecord::Migration[7.1]
  def change
    add_column :control_units, :identificacion_registral, :jsonb
  end
end
