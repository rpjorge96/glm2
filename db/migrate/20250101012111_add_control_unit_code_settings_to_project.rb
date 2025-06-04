class AddControlUnitCodeSettingsToProject < ActiveRecord::Migration[7.1]
  def change
    default_control_unit_code_settings = {
      "numero_inicial" => false,
      "sufijos" => false,
      "re_compra" => false,
      "re_venta" => false
    }.to_json

    remove_column :projects, :control_unit_code_settings, :string, array: true, default: []
    add_column :projects, :control_unit_code_settings, :jsonb, default: default_control_unit_code_settings
  end
end
