# frozen_string_literal: true

class ChangeEmailNullOnUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_null :users, :email, true
  end
end
