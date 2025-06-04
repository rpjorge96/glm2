class CreateListadoDePrecios < ActiveRecord::Migration[7.1]
  def change
    create_table :listado_de_precios do |t|
      t.references :control_unit, null: false, foreign_key: true
      t.integer :precio_de_lista_cents
      t.integer :contado_cents
      t.integer :meses_24_cents
      t.integer :enganche_cents

      t.timestamps
    end
  end
end
