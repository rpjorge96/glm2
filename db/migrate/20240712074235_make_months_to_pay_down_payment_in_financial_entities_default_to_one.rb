class MakeMonthsToPayDownPaymentInFinancialEntitiesDefaultToOne < ActiveRecord::Migration[7.1]
  def change
    change_column_default :financial_entities, :months_to_pay_down_payment, 1
  end
end
