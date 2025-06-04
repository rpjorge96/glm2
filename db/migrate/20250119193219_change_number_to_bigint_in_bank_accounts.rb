class ChangeNumberToBigintInBankAccounts < ActiveRecord::Migration[7.1]
  def up
    change_column :bank_accounts, :number, :bigint, using: "number::bigint"
  end

  def down
    change_column :bank_accounts, :number, :integer, using: "number::integer"
  end
end
