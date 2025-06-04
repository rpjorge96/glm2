class AddMaxDiscountToRole < ActiveRecord::Migration[7.1]
  def change
    add_column :roles, :max_allowed_discount_percentage, :decimal, precision: 5, scale: 2, default: 0.0
  end
end
