class RenameDownPaymentDiscountPercentageInFinancialEntities < ActiveRecord::Migration[7.1]
  def change
    rename_column :financial_entities, :down_payment_discount_percentage, :discount_percentage
  end
end
