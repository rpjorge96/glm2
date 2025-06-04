class AddColorsToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :title_color, :string
    add_column :projects, :price_color, :string
    add_column :projects, :final_price_color, :string
    add_column :projects, :bg_field_color, :string
  end
end
