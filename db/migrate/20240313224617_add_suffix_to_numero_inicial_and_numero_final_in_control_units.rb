class AddSuffixToNumeroInicialAndNumeroFinalInControlUnits < ActiveRecord::Migration[7.1]
  def change
    remove_column :control_units, :code_suffix
    add_column :control_units, :numero_inicial_suffix, :string
    add_column :control_units, :numero_final_suffix, :string
  end
end
