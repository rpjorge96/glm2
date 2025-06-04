class AddPropietaryAndServiceCompanyToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :propietary, :string
    add_column :projects, :service_company, :string
  end
end
