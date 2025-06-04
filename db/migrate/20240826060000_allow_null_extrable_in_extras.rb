class AllowNullExtrableInExtras < ActiveRecord::Migration[7.1]
  def change
    change_column_null :extras, :extrable_type, true
    change_column_null :extras, :extrable_id, true
  end
end
