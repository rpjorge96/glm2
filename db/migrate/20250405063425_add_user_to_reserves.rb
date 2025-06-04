class AddUserToReserves < ActiveRecord::Migration[7.1]
  def change
    add_reference :reserves, :user, foreign_key: true
  end
end
