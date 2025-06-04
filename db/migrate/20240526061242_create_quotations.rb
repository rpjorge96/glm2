class CreateQuotations < ActiveRecord::Migration[7.1]
  def change
    create_table :quotations do |t|
      t.string :client_name
      t.string :client_phone
      t.string :client_email
      t.integer :duration_in_months
      t.decimal :down_payment_percentage
      t.decimal :interest_rate
      t.references :control_unit, null: false, foreign_key: true
      t.references :financial_entity, null: false, foreign_key: true

      t.timestamps
    end
  end
end
