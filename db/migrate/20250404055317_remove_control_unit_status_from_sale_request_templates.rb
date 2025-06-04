class RemoveControlUnitStatusFromSaleRequestTemplates < ActiveRecord::Migration[7.1]
  def change
    remove_reference :sale_request_templates, :control_unit_status, foreign_key: true
  end
end
