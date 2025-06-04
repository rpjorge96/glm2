class CreatePayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payments do |t|
      t.references :control_unit_payment_detail, null: false, foreign_key: true
      t.integer :payment_type, null: false
      t.references :payment_method, null: false, foreign_key: true
      t.references :bank_account, null: false, foreign_key: true
      t.string :reference_number
      t.datetime :transaction_date, null: false
      t.decimal :quantity, null: false, precision: 10, scale: 2
      t.string :description
      t.integer :status, default: 0, null: false
      t.references :created_by_user, null: false, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
