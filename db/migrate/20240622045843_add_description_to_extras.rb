class AddDescriptionToExtras < ActiveRecord::Migration[7.1]
  def change
    add_column :extras, :description, :string
  end
end
