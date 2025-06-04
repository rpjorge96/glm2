class RemoveEdadFromClients < ActiveRecord::Migration[7.1]
  def change
    remove_column :clients, :edad, :integer
  end
end
