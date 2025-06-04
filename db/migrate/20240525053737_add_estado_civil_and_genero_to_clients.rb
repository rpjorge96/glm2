class AddEstadoCivilAndGeneroToClients < ActiveRecord::Migration[7.1]
  def change
    add_column :clients, :estado_civil, :integer
    add_column :clients, :género, :integer
  end
end
