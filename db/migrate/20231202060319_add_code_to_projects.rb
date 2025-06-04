class AddCodeToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :code, :integer, null: false, default: 0
  end
end
