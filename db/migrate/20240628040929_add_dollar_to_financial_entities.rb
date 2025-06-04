class AddDollarToFinancialEntities < ActiveRecord::Migration[7.1]
  def change
    add_monetize :financial_entities,
      :minimum_down_payment_dollar,
      amount: {null: true, default: nil},
      currency: {null: false, default: "USD"}
  end
end
