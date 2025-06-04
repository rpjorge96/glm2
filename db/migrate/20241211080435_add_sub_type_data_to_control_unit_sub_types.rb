class AddSubTypeDataToControlUnitSubTypes < ActiveRecord::Migration[7.1]
  def change
    add_column :control_unit_sub_types, :subtype_data, :jsonb
  end
end
