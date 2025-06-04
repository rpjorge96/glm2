class AddMonthsToPayDownPaymentToFinancialEntities < ActiveRecord::Migration[7.1]
  def change
    add_column :financial_entities, :months_to_pay_down_payment, :integer
  end
end
