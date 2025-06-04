class AddPhoneAndNameToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :phone, :string
    add_column :users, :name, :string
  end
end
