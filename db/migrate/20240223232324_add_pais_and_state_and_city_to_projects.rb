class AddPaisAndStateAndCityToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :país, :string
    add_column :projects, :departamento_estado, :string
    add_column :projects, :municipio_ciudad, :string

    Project.all.each do |project|
      country = case project.country
      when 0
        "Guatemala"
      when 1
        "Estados Unidos"
      end
      project.update(:país => country)
    end

    remove_column :projects, :country
  end
end
