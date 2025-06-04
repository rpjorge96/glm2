class AddAddressAndContactPreferenceToClients < ActiveRecord::Migration[7.1]
  def up
    add_column :clients, :address, :string, null: true
    add_column :clients, :contact_preference, :integer, null: true
  end

  def down
    remove_column :clients, :address
    remove_column :clients, :contact_preference
  end
end
