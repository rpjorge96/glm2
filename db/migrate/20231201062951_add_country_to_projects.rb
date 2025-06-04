class AddCountryToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :country, :integer, default: 0
  end
end
