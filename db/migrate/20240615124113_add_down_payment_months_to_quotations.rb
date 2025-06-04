class AddDownPaymentMonthsToQuotations < ActiveRecord::Migration[7.1]
  def change
    add_column :quotations, :down_payment_months, :integer
  end
end
