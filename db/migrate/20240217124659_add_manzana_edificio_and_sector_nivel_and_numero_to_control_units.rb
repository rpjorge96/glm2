class AddManzanaEdificioAndSectorNivelAndNumeroToControlUnits < ActiveRecord::Migration[7.1]
  def change
    add_column :control_units, :manzana_edificio, :string
    add_column :control_units, :sector_nivel, :string
    add_column :control_units, :número_inicial, :integer
    add_column :control_units, :número_final, :integer

    add_index :control_units, :manzana_edificio
    add_index :control_units, :sector_nivel
    add_index :control_units, :número_inicial
    add_index :control_units, :número_final
  end
end
