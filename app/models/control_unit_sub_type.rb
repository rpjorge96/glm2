# frozen_string_literal: true

# == Schema Information
#
# Table name: control_unit_sub_types
#
#  id                               :bigint           not null, primary key
#  active_maintenance_fee_cents     :integer
#  active_maintenance_fee_currency  :string
#  active_maintenance_fee_dollars   :decimal(, )
#  balconies_terrace_area           :decimal(10, 2)
#  description                      :string
#  garden_area                      :decimal(10, 2)
#  img2_desc                        :string
#  img3_desc                        :string
#  img4_desc                        :string
#  lotes_minimos                    :integer
#  name                             :string
#  parking_spaces                   :integer
#  parking_type                     :string
#  passive_maintenance_fee_cents    :integer
#  passive_maintenance_fee_currency :string
#  passive_maintenance_fee_dollars  :decimal(, )
#  subtype_data                     :jsonb
#  subtype_variable_data            :jsonb
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  control_unit_type_id             :bigint           not null
#
# Indexes
#
#  index_control_unit_sub_types_on_control_unit_type_id  (control_unit_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (control_unit_type_id => control_unit_types.id)
#
class ControlUnitSubType < ApplicationRecord
  after_initialize :set_default_subtype_data, if: :new_record?
  before_save :capitalize_first_letter_of_name

  belongs_to :control_unit_type

  has_many :control_unit_sub_type_projects, dependent: :destroy
  has_many :projects, through: :control_unit_sub_type_projects
  has_many :control_units,
    foreign_key: "control_unit_sub_type",
    primary_key: "name",
    class_name: "ControlUnit"

  has_one_attached :plano_del_subtipo
  has_one_attached :detalles_constructivos
  has_one_attached :imagen1
  has_one_attached :imagen2
  has_one_attached :imagen3
  has_one_attached :imagen4

  validates :name,
    presence: true,
    uniqueness: {scope: :control_unit_type_id, case_sensitive: false,
                 message: "y tipo ya existen."}
  validates :imagen1, attachment_size: true
  validates :imagen2, attachment_size: true
  validates :imagen3, attachment_size: true
  validates :imagen4, attachment_size: true

  monetize :active_maintenance_fee_cents, allow_nil: true
  monetize :passive_maintenance_fee_cents, allow_nil: true

  scope :for_project, ->(project_id) { joins(:projects).where(projects: {id: project_id}) }

  def total_area
    construction_area.to_f + garden_balcony_area.to_f + terrace_area.to_f + laundry_area.to_f + pergola_area.to_f
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[control_unit_type projects]
  end

  private

  def capitalize_first_letter_of_name
    self.name = name.split.map { |word| word[0].upcase + word[1..] }.join(" ")
  end

  def set_default_subtype_data
    self.subtype_data ||= {}
  end
end
