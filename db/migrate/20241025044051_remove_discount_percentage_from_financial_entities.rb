class RemoveDiscountPercentageFromFinancialEntities < ActiveRecord::Migration[7.1]
  def change
    remove_column :financial_entities, :discount_percentage, :decimal, precision: 5, scale: 2
  end
end
