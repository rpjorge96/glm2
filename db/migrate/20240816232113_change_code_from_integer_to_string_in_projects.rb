class ChangeCodeFromIntegerToStringInProjects < ActiveRecord::Migration[7.1]
  def up
    change_column :projects, :code, :string
  end

  def down
    change_column :projects, :code, :integer
  end
end
