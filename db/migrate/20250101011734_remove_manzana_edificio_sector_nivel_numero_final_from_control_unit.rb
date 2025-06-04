class RemoveManzanaEdificioSectorNivelNumeroFinalFromControlUnit < ActiveRecord::Migration[7.1]
  def change
    remove_column :control_units, :manzana_edificio, :string
    remove_column :control_units, :sector_nivel, :string
    remove_column :control_units, :número_final, :string
    remove_column :control_units, :número_inicial, :string
    remove_column :control_units, :numero_inicial_suffix, :string
    remove_column :control_units, :numero_final_suffix, :string
  end
end
