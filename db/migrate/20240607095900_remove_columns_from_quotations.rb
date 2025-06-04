class RemoveColumnsFromQuotations < ActiveRecord::Migration[7.1]
  def change
    remove_column :quotations, :down_payment_percentage, :decimal
    remove_column :quotations, :duration_in_months, :integer
    remove_column :quotations, :interest_rate, :decimal
    add_column :quotations, :quotation_params, :jsonb
  end
end
