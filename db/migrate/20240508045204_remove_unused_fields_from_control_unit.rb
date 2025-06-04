class RemoveUnusedFieldsFromControlUnit < ActiveRecord::Migration[7.1]
  def change
    remove_column :control_units, :registered_at, :date
    remove_column :control_units, :notary, :string
    remove_column :control_units, :writing_date, :date
    remove_column :control_units, :writing_number, :string
  end
end
