class AddPdfGeneratedAtToQuotation < ActiveRecord::Migration[7.1]
  def change
    add_column :quotations, :pdf_generated_at, :datetime
  end
end
