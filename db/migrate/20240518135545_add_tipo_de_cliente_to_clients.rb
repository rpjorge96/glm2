class AddTipoDeClienteToClients < ActiveRecord::Migration[7.1]
  def change
    add_column :clients, :tipo_de_cliente, :integer
  end
end
