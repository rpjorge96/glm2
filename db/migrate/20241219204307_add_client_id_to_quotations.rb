class AddClientIdToQuotations < ActiveRecord::Migration[7.1]
  def change
    add_column :quotations, :client_id, :integer, null: true
  end
end
