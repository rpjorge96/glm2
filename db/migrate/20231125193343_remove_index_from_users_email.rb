# frozen_string_literal: true

class RemoveIndexFromUsersEmail < ActiveRecord::Migration[7.1]
  def change
    remove_index :users, name: "index_users_on_email"
  end
end
