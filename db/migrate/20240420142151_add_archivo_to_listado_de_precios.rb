class AddArchivoToListadoDePrecios < ActiveRecord::Migration[7.1]
  def change
    add_reference :listado_de_precios, :archivo, foreign_key: {to_table: :listado_de_precio_archivos}
  end
end
