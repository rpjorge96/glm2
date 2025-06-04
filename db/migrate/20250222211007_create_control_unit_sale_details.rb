class CreateControlUnitSaleDetails < ActiveRecord::Migration[7.1]
  def up
    create_table :control_unit_applicants do |t|
      t.references :client, null: false, foreign_key: {to_table: :clients}
      t.references :control_unit, null: false, foreign_key: {to_table: :control_units}
      t.integer :applicant_type

      t.timestamps
    end
    create_table :control_unit_sale_details do |t|
      t.references :control_unit, null: false, foreign_key: {to_table: :control_units}
      t.references :applicant_1, null: true, foreign_key: {to_table: :clients}
      t.references :applicant_2, null: true, foreign_key: {to_table: :clients}

      t.string :currency
      t.boolean :includes_deed_expenses

      # Extra data of the property
      t.float :construction_area
      t.float :garden_area
      t.integer :parking_spaces
      t.float :balcony_area
      t.float :total_area
      t.string :parking_type
      t.date :estimated_delivery_date

      # Form of Payment
      t.float :total_value
      t.float :down_payment
      t.float :balance
      t.integer :installment
      t.float :monthly_installment
      t.date :maximum_day

      t.timestamps
    end
  end

  def down
    drop_table :control_unit_applicants
    drop_table :control_unit_sale_details
  end
end
