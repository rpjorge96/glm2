class CreateListadoDePrecioArchivos < ActiveRecord::Migration[7.1]
  def change
    create_table :listado_de_precio_archivos do |t|
      t.string :nombre
      t.date :fecha_de_listado

      t.timestamps
    end
  end
end
