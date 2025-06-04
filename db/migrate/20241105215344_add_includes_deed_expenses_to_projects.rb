class AddIncludesDeedExpensesToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :includes_deed_expenses, :boolean, default: false
  end
end
