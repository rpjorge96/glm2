class RenameTypeToMethodTypeInPaymentMethods < ActiveRecord::Migration[7.1]
  def change
    rename_column :payment_methods, :type, :method_type
  end
end
