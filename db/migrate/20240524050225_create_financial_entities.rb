class CreateFinancialEntities < ActiveRecord::Migration[7.1]
  def change
    create_table :financial_entities do |t|
      t.string :name
      t.decimal :annual_interest_rate
      t.decimal :down_payment_percentage
      t.decimal :down_payment_discount_percentage
      t.integer :financing_type

      t.timestamps
    end
  end
end
