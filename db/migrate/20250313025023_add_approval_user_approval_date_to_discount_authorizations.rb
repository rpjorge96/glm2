class AddApprovalUserApprovalDateToDiscountAuthorizations < ActiveRecord::Migration[7.1]
  def change
    add_column :discount_authorizations, :approval_user_id, :integer
    add_column :discount_authorizations, :approval_date, :datetime
  end
end
