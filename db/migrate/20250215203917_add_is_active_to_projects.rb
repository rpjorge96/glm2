class AddIsActiveToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :is_active, :boolean, null: false, default: false
  end
end
