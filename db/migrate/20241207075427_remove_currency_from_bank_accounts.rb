class RemoveCurrencyFromBankAccounts < ActiveRecord::Migration[7.1]
  def change
    remove_column :bank_accounts, :currency
  end
end
