class AddColumnsToControlUnitSaleDetails < ActiveRecord::Migration[7.1]
  def change
    add_column :control_unit_sale_details, :purchase_date, :date
    add_column :control_unit_sale_details, :selling_price, :float
    add_column :control_unit_sale_details, :seller, :string

    # cash advance
    rename_column :control_unit_sale_details, :balance, :cash_advance_balance
    rename_column :control_unit_sale_details, :total_value, :cash_advance
    add_column :control_unit_sale_details, :cash_advance_interest_rate, :float

    # balance
    add_column :control_unit_sale_details, :payment_method, :float
    add_column :control_unit_sale_details, :flp, :string
    add_column :control_unit_sale_details, :balance, :float
    add_column :control_unit_sale_details, :transfer, :float
    add_column :control_unit_sale_details, :disbursement_date, :date
    add_column :control_unit_sale_details, :bank, :string
    add_column :control_unit_sale_details, :file, :string

    # self-financing
    add_column :control_unit_sale_details, :credit_value, :float
    add_column :control_unit_sale_details, :finance_plan, :string
    add_column :control_unit_sale_details, :term, :string
    add_column :control_unit_sale_details, :payment_day, :date
    add_column :control_unit_sale_details, :monthly_payment, :float
    add_column :control_unit_sale_details, :annual_interest_rate, :float
    add_column :control_unit_sale_details, :self_financing_interest_rate, :string
    add_column :control_unit_sale_details, :remarks, :string
  end
end
