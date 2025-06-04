class CreateTipoDeIdentificacionClientes < ActiveRecord::Migration[7.1]
  def change
    create_table :tipo_de_identificacion_clientes do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
