class AddMinimumDownPaymentAndMaximumYearsToFinanceToFinancialEntity < ActiveRecord::Migration[7.1]
  def change
    add_monetize :financial_entities,
      :minimum_down_payment,
      amount: {null: true, default: nil},
      currency: {null: true, default: nil}
    add_column :financial_entities, :maximum_years_to_finance, :integer
  end
end
