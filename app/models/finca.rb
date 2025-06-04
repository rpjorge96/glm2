# frozen_string_literal: true

# == Schema Information
#
# Table name: fincas
#
#  id             :bigint           not null, primary key
#  departamento   :string
#  folio          :string
#  libro          :string
#  número         :string
#  propietario    :string
#  remaining_area :float
#  área           :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  project_id     :bigint           not null
#
# Indexes
#
#  index_fincas_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
class Finca < ApplicationRecord
  belongs_to :project
  has_many :control_units, dependent: :nullify

  def codigo
    "#{número}-#{folio}-#{libro}"
  end

  def remanente
    total_area = control_units.sum(:area_desmembracion) || 0
    self.área ||= 0
    if total_area.present?
      (self.área - total_area)
    else
      self.área
    end
  end

  # Método para buscar una finca por su código
  def self.find_by_codigo(codigo)
    return unless codigo.present?

    número, folio, libro = codigo.split("-")
    find_by(:número => número, :folio => folio, :libro => libro)
  end
end
