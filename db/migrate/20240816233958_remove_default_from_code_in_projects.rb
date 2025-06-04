class RemoveDefaultFromCodeInProjects < ActiveRecord::Migration[7.1]
  def up
    change_column_default :projects, :code, from: "0", to: nil
  end

  def down
    change_column_default :projects, :code, from: nil, to: "0"
  end
end
