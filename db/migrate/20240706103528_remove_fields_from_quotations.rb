class RemoveFieldsFromQuotations < ActiveRecord::Migration[7.1]
  def change
    remove_column :quotations, :control_unit_id, :bigint
    remove_column :quotations, :financial_entity_id, :bigint
  end
end
