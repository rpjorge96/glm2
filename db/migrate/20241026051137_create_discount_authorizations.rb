class CreateDiscountAuthorizations < ActiveRecord::Migration[7.1]
  def change
    create_table :discount_authorizations do |t|
      t.references :quotation, null: false, foreign_key: true
      t.string :comment
      t.boolean :approved, default: false

      t.timestamps
    end
  end
end
