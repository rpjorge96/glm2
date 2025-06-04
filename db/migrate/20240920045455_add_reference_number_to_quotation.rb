class AddReferenceNumberToQuotation < ActiveRecord::Migration[7.1]
  def change
    add_column :quotations, :reference_number, :string
  end
end
