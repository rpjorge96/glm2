class AddCodeSettingsToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :control_unit_code_settings, :string, array: true, default: []
  end
end
