# frozen_string_literal: true

# == Schema Information
#
# Table name: extras
#
#  id                     :bigint           not null, primary key
#  description            :string
#  extrable_type          :string
#  name                   :string
#  precio_cents           :integer
#  precio_currency        :string
#  precio_dollar_cents    :integer
#  precio_dollar_currency :string           default("USD"), not null
#  unidades_de_medida     :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  extrable_id            :bigint
#
# Indexes
#
#  index_extras_on_extrable           (extrable_type,extrable_id)
#  index_extras_on_extrable_and_name  (extrable_type,extrable_id,name) UNIQUE
#
class Extra < ApplicationRecord
  belongs_to :extrable, polymorphic: true, optional: true

  has_one_attached :adjunto

  has_many :control_unit_types_projects_extras
  has_many :control_unit_types_projects, through: :control_unit_types_projects_extras
  has_many :projects, through: :control_unit_types_projects
  has_many :control_unit_types, through: :control_unit_types_projects

  monetize :precio_cents, allow_nil: true
  monetize :precio_dollar_cents, allow_nil: true

  validates :name, presence: true
  validates :name, uniqueness: {scope: %i[extrable_type extrable_id], message: "ya existe"}
  validates :adjunto, attachment_size: true

  enum unidades_de_medida: {
    :unidad => 0, # unidad
    :m => 1, # metro lineal
    :m² => 2,   # metro cuadrado
    :m³ => 3,   # metro cúbico
    :ft => 4,   # pie lineal
    :ft² => 5,   # pie cuadrado
    :ft³ => 6    # pie cúbico
  }

  scope :generales, -> { where(extrable_id: nil) } # para manejar extras generales

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at description extrable_id extrable_type id id_value name precio_cents
      precio_currency precio_dollar_cents precio_dollar_currency updated_at]
  end

  # Método de clase para encontrar extras asociados a un project y control_unit_type específicos usando IDs
  def self.for_project_and_control_unit_type(project_id, control_unit_type_id)
    # Encuentra el proyecto por su ID
    project = Project.find_by(id: project_id)
    # Encuentra el control_unit_type por su ID
    control_unit_type = control_unit_type_id ? ControlUnitType.find(control_unit_type_id) : nil

    return [] if project.nil? || control_unit_type.nil?

    # Encuentra las combinaciones en control_unit_types_projects
    control_unit_types_projects = ControlUnitTypesProject.where(
      project:,
      control_unit_type:
    )

    # Encuentra los extras asociados a estas combinaciones
    Extra.joins(:control_unit_types_projects_extras)
      .where(control_unit_types_projects_extras:
         {control_unit_types_project_id: control_unit_types_projects.select(:id)})
  end

  def project_and_type_names
    control_unit_types_projects
      .includes(:project, :control_unit_type) # Eager load para evitar consultas N+1
      .order("projects.name", "control_unit_types.name") # Ordenar por project.name y luego por control_unit_type.name
      .map do |cup|
        "[#{cup.project.name}, #{cup.control_unit_type.name}]"
      end
  end
end
