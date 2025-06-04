class CreateBankAccounts < ActiveRecord::Migration[7.1]
  def change
    create_table :bank_accounts do |t|
      t.string :bank_name
      t.integer :number
      t.string :currency

      t.timestamps
    end
  end
end
