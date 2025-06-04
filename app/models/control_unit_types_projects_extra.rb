# frozen_string_literal: true

# == Schema Information
#
# Table name: control_unit_types_projects_extras
#
#  id                            :bigint           not null, primary key
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  control_unit_types_project_id :bigint           not null
#  extra_id                      :bigint           not null
#
# Indexes
#
#  idx_on_control_unit_types_project_id_f556e6c56f       (control_unit_types_project_id)
#  index_control_unit_types_projects_extras_on_extra_id  (extra_id)
#  index_on_extra_and_control_unit_and_project           (extra_id,control_unit_types_project_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (control_unit_types_project_id => control_unit_types_projects.id)
#  fk_rails_...  (extra_id => extras.id)
#
class ControlUnitTypesProjectsExtra < ApplicationRecord
  belongs_to :control_unit_types_project
  belongs_to :extra

  validate :unique_extra_project_control_unit_type_combination

  private

  def unique_extra_project_control_unit_type_combination
    # Verifica si ya existe una combinación de extra, project, y control_unit_type
    if ControlUnitTypesProjectsExtra.joins(:control_unit_types_project)
        .where(extra_id:)
        .where(control_unit_types_projects: {
          control_unit_type_id: control_unit_types_project.control_unit_type_id,
          project_id: control_unit_types_project.project_id
        })
        .exists?
      errors.add(:base, "La combinación de extra, proyecto y tipo de unidad de control ya existe.")
    end
  end
end
