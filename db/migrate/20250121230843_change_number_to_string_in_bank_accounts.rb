class ChangeNumberToStringInBankAccounts < ActiveRecord::Migration[7.1]
  def up
    change_column :bank_accounts, :number, :string
  end

  def down
    change_column :bank_accounts, :number, :bigint, using: "number::bigint"
  end
end
