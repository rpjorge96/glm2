class AddIndexToExtrasOnExtrableAndName < ActiveRecord::Migration[7.1]
  def change
    add_index :extras, [:extrable_type, :extrable_id, :name], unique: true, name: "index_extras_on_extrable_and_name"
  end
end
