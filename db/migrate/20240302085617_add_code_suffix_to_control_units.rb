class AddCodeSuffixToControlUnits < ActiveRecord::Migration[7.1]
  def change
    add_column :control_units, :code_suffix, :string
  end
end
