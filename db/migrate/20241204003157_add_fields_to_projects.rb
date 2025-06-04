class AddFieldsToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :days_to_book, :integer
    add_column :projects, :internal_code, :string, limit: 4
  end
end
