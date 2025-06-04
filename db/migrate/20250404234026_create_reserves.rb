class CreateReserves < ActiveRecord::Migration[7.1]
  def change
    create_table :reserves do |t|
      t.integer :quantity
      t.integer :receipt_number
      t.references :quotation, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
