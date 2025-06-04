class ChangeApprovedToStatusInDiscountAuthorizations < ActiveRecord::Migration[7.1]
  def change
    remove_column :discount_authorizations, :approved, :boolean
    add_column :discount_authorizations, :status, :integer, default: 0
    add_column :discount_authorizations, :sale_value, :integer
    add_column :discount_authorizations, :discount_value, :integer
    add_column :discount_authorizations, :approval_reason, :string
  end
end
