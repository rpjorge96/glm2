# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id                         :bigint           not null, primary key
#  bg_field_color             :string
#  code                       :string           not null
#  control_unit_code_settings :jsonb
#  days_to_book               :integer
#  departamento_estado        :string
#  description                :string
#  discarded_at               :datetime
#  final_price_color          :string
#  includes_deed_expenses     :boolean          default(FALSE)
#  internal_code              :string(4)
#  is_active                  :boolean          default(FALSE), not null
#  municipio_ciudad           :string
#  name                       :string
#  operation_initial_date     :date
#  país                       :string
#  phone                      :string
#  price_color                :string
#  propietary                 :string
#  quotation_valid_days       :integer
#  service_company            :string
#  social_media_links         :jsonb
#  title_color                :string
#  website_url                :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
# Indexes
#
#  index_projects_on_discarded_at  (discarded_at)
#
class Project < ApplicationRecord
  include Discard::Model
  after_initialize :set_default_code, if: :new_record?
  after_commit :save_city, on: %i[create update]
  before_validation :ensure_two_digits_code

  has_many :control_units, dependent: :destroy
  has_many :import_logs, as: :importable
  has_many :fincas, dependent: :destroy
  has_many :control_unit_sub_type_projects, dependent: :destroy
  has_many :control_unit_sub_types, through: :control_unit_sub_type_projects
  # used for handling extras
  has_many :control_unit_types_projects, dependent: :destroy
  has_many :control_unit_types, through: :control_unit_types_projects
  # used for handling extras

  has_one_attached :plano_del_proyecto
  has_one_attached :project_logo
  has_one_attached :pdf_header
  has_one_attached :pdf_footer
  has_one_attached :icon1
  has_one_attached :icon2
  has_one_attached :icon3
  has_one_attached :icon4

  has_and_belongs_to_many :sale_request_templates
  has_and_belongs_to_many :users

  accepts_nested_attributes_for :fincas, allow_destroy: true

  validates :name, :code, presence: true, uniqueness: true
  validates :days_to_book, numericality: {only_integer: true, greater_than: 0}, allow_blank: true
  validates :internal_code, uniqueness: true, length: {maximum: 4, message: "No puede tener más de 4 caracteres."}, allow_blank: true
  validate :municipio_ciudad_pertenece_a_departamento_estado
  validates :internal_code, presence: true
  validates :pdf_header, attachment_size: true
  validates :pdf_footer, attachment_size: true
  validates :project_logo, attachment_size: true

  scope :active, -> { where(is_active: true) }
  default_scope { order(:code) }

  def self.ransackable_attributes(_auth_object = nil)
    %w[code departamento_estado municipio_ciudad name país]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[control_units fincas import_logs versions]
  end

  # ransacker :code do
  #   Arel.sql("to_char(code, '999999999')")
  # end

  def first_country_letter
    country[0]
  end

  def country_code
    country_class&.alpha2
  end

  def subdivision_code
    subdivision_class&.code
  end

  def two_digits_code
    code.to_s.rjust(2, "0")
  end

  def code_with_country
    "#{country_code}-#{code}"
  end

  def country_class
    Country.find_country_by_any_name(país)
  end

  def subdivision_class
    country_class&.find_subdivision_by_name(departamento_estado)
  end

  def icon1_url
    return nil if social_media_links.blank?

    JSON.parse(social_media_links)["icon1"]
  end

  def icon2_url
    return nil if social_media_links.blank?

    JSON.parse(social_media_links)["icon2"]
  end

  def icon3_url
    return nil if social_media_links.blank?

    JSON.parse(social_media_links)["icon3"]
  end

  def icon4_url
    return nil if social_media_links.blank?

    JSON.parse(social_media_links)["icon4"]
  end

  def parsed_control_unit_code_settings
    JSON.parse(control_unit_code_settings)
  end

  def custom_control_unit_code_settings
    settings = parsed_control_unit_code_settings
    settings.delete("numero_inicial")
    settings.delete("sufijos")
    settings.delete("re_compra")
    settings.delete("re_venta")
    settings
  end

  def standard_control_unit_code_settings
    settings = parsed_control_unit_code_settings
    settings.keep_if { |k, v| %w[numero_inicial].include?(k) && v }
  end

  def control_unit_code_settings_suffix_enabled?
    parsed_control_unit_code_settings["sufijos"]
  end

  private

  def set_default_code
    self.code = (Project.maximum(:code).to_i + 1).to_s.rjust(2, "0") if code.blank?
  end

  def municipio_ciudad_pertenece_a_departamento_estado
    return if municipio_ciudad.blank?

    return unless departamento_estado.blank? || país.blank?

    errors.add(:municipio_ciudad, "debe tener un departamento/estado y país asignado")
  end

  def save_city
    return if municipio_ciudad.blank?

    municipio_ciudad = self.municipio_ciudad.split.map { |word| word[0].upcase + word[1..] }.join(" ")

    city = City.find_or_create_by(name: municipio_ciudad, state_code: subdivision_code, country_code:)

    update_columns(municipio_ciudad: city.name)
  end

  def ensure_two_digits_code
    self.code = two_digits_code
  end
end
