class AddFieldsToRoles < ActiveRecord::Migration[7.1]
  def change
    add_column :roles, :max_days_extend_reservation, :integer
    add_column :roles, :max_days_extend_quotation, :integer
  end
end
