class AddNotesToFinancialEntities < ActiveRecord::Migration[7.1]
  def change
    add_column :financial_entities,
      :notes, :jsonb,
      default: {},
      null: false
  end
end
