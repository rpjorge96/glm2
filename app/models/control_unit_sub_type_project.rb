# frozen_string_literal: true

# == Schema Information
#
# Table name: control_unit_sub_type_projects
#
#  id                       :bigint           not null, primary key
#  precio_cents             :integer
#  precio_currency          :string
#  precio_dollar_cents      :integer
#  precio_dollar_currency   :string           default("USD"), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  control_unit_sub_type_id :bigint           not null
#  project_id               :bigint           not null
#
# Indexes
#
#  idx_on_control_unit_sub_type_id_422e348ac9          (control_unit_sub_type_id)
#  index_control_unit_sub_type_projects_on_project_id  (project_id)
#  unique_project_and_control_unit_sub_type            (project_id,control_unit_sub_type_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (control_unit_sub_type_id => control_unit_sub_types.id)
#  fk_rails_...  (project_id => projects.id)
#
class ControlUnitSubTypeProject < ApplicationRecord
  belongs_to :project
  belongs_to :control_unit_sub_type

  has_many :extras, as: :extrable

  monetize :precio_cents, allow_nil: true
  monetize :precio_dollar_cents, allow_nil: true
end
