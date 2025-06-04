# frozen_string_literal: true

# == Schema Information
#
# Table name: control_unit_types_projects
#
#  id                   :bigint           not null, primary key
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  control_unit_type_id :bigint           not null
#  project_id           :bigint           not null
#
# Indexes
#
#  index_control_unit_type_project_uniqueness                 (control_unit_type_id,project_id) UNIQUE
#  index_control_unit_types_projects_on_control_unit_type_id  (control_unit_type_id)
#  index_control_unit_types_projects_on_project_id            (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (control_unit_type_id => control_unit_types.id)
#  fk_rails_...  (project_id => projects.id)
#
class ControlUnitTypesProject < ApplicationRecord
  belongs_to :control_unit_type
  belongs_to :project

  has_many :control_unit_types_projects_extras
  has_many :extras, through: :control_unit_types_projects_extras

  validates :control_unit_type_id, uniqueness: {scope: :project_id, message: "ya está asignado a este proyecto"}
end
