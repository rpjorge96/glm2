# frozen_string_literal: true

# == Schema Information
#
# Table name: control_unit_types
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ControlUnitType < ApplicationRecord
  before_save :capitalize_first_letter_of_name
  # used for handling extras
  has_many :control_unit_types_projects
  has_many :projects, through: :control_unit_types_projects
  # used for handling extras

  has_many :control_unit_sub_types

  validates :name, uniqueness: {case_sensitive: false, message: "del tipo de unidad de control ya fue ingresado"}

  def self.ransackable_attributes(_auth_object = nil)
    %w[name]
  end

  private

  def capitalize_first_letter_of_name
    self.name = name.split.map { |word| word[0].upcase + word[1..] }.join(" ")
  end
end
