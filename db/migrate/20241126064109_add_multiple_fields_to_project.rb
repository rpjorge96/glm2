class AddMultipleFieldsToProject < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :quotation_valid_days, :integer
    add_column :projects, :social_media_links, :jsonb
  end
end
