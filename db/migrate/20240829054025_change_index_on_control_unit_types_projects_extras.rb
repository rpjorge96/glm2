class ChangeIndexOnControlUnitTypesProjectsExtras < ActiveRecord::Migration[7.1]
  def up
    # Remover el índice existente que asegura la unicidad de (control_unit_types_project_id, extra_id)
    remove_index :control_unit_types_projects_extras, name: "index_cup_on_project_and_extra"

    # Crear un nuevo índice único que combine extra_id, control_unit_type_id y project_id
    add_index :control_unit_types_projects_extras, [:extra_id, :control_unit_types_project_id], unique: true, name: "index_on_extra_and_control_unit_and_project"
  end

  def down
    # Remover el índice único creado en 'up'
    remove_index :control_unit_types_projects_extras, name: "index_on_extra_and_control_unit_and_project"

    # Restaurar el índice original que combina (control_unit_types_project_id, extra_id)
    add_index :control_unit_types_projects_extras, [:control_unit_types_project_id, :extra_id], unique: true, name: "index_cup_on_project_and_extra"
  end
end
