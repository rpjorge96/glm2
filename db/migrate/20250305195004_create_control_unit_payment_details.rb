class CreateControlUnitPaymentDetails < ActiveRecord::Migration[7.1]
  def up
    create_table :control_unit_payment_details do |t|
      t.references :control_unit, null: true, foreign_key: {to_table: :control_units}

      # Down payment
      t.string :hookup
      t.float :down_payment_installment
      t.date :last_down_payment_date
      t.integer :down_payment_installments
      t.integer :total_installments
      t.float :down_payment_balance
      t.date :next_down_payment_date

      # Balance
      t.float :balance
      t.string :payment_method
      t.float :monthly_payment
      t.integer :balance_installments
      t.date :start_date
      t.float :total_balance

      # Sections
      t.jsonb :extra_payments, default: []
      t.jsonb :down_payments, default: []
      t.jsonb :monthly_payments, default: []
      t.jsonb :late_payments, default: []
      t.jsonb :capital_payments, default: []
      t.jsonb :total_payments, default: []

      t.string :remarks

      t.timestamps
    end
  end

  def down
    drop_table :control_unit_payment_details
  end
end
