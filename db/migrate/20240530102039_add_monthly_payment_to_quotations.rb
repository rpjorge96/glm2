class AddMonthlyPaymentToQuotations < ActiveRecord::Migration[7.1]
  def change
    add_monetize :quotations,
      :monthly_payment,
      amount: {null: true, default: nil},
      currency: {null: true, default: nil}
  end
end
