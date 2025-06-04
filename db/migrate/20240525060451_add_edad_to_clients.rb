class AddEdadToClients < ActiveRecord::Migration[7.1]
  def change
    add_column :clients, :edad, :integer
  end
end
