class AddCodeValuesToControlUnit < ActiveRecord::Migration[7.1]
  def change
    add_column :control_units, :code_values, :jsonb, default: {}
  end
end
