class RemoveEstadoCivilAndGeneroFromClients < ActiveRecord::Migration[7.1]
  def change
    remove_column :clients, :estado_civil, :string
    remove_column :clients, :género, :string
  end
end
