class AddCurrencyToBankAccounts < ActiveRecord::Migration[7.1]
  def change
    add_column :bank_accounts, :currency, :integer
  end
end
