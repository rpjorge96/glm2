class ChangeColumnsInControlUnitSaleDetail < ActiveRecord::Migration[7.1]
  def up
    change_column :control_unit_sale_details, :maximum_day, "integer USING NULL::integer"
    change_column :control_unit_sale_details, :payment_day, "integer USING NULL::integer"
    change_column :control_unit_sale_details, :term, "integer USING NULL::integer"
    change_column :control_unit_sale_details, :self_financing_interest_rate, "float USING NULL::float"

    add_column :control_unit_sale_details, :finance_type, :integer
    add_column :control_unit_sale_details, :request_number, :string
    add_column :control_unit_sale_details, :property_dynamic_fields, :jsonb

    remove_column :control_unit_sale_details, :payment_method
    remove_column :control_unit_sale_details, :flp
    remove_column :control_unit_sale_details, :transfer
    remove_column :control_unit_sale_details, :disbursement_date
    remove_column :control_unit_sale_details, :credit_value
  end

  def down
    change_column :control_unit_sale_details, :maximum_day, "date USING NULL::date"
    change_column :control_unit_sale_details, :payment_day, "date USING NULL::date"
    change_column :control_unit_sale_details, :term, :string
    change_column :control_unit_sale_details, :self_financing_interest_rate, :string

    remove_column :control_unit_sale_details, :finance_type
    remove_column :control_unit_sale_details, :request_number
    remove_column :control_unit_sale_details, :property_dynamic_fields

    add_column :control_unit_sale_details, :payment_method, :float
    add_column :control_unit_sale_details, :flp, :string
    add_column :control_unit_sale_details, :transfer, :float
    add_column :control_unit_sale_details, :disbursement_date, :date
    add_column :control_unit_sale_details, :credit_value, :float
  end
end
