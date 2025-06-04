class AddTipoDeIdentificacionClienteToClients < ActiveRecord::Migration[7.1]
  def change
    add_reference :clients, :tipo_de_identificacion_cliente, foreign_key: true
    add_index :clients, [:tipo_de_identificacion_cliente_id, :dpi], unique: true, name: "index_unique_tipo_identificacion_dpi"
  end
end
