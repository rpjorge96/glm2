# frozen_string_literal: true

# == Schema Information
#
# Table name: control_unit_statuses
#
#  id         :bigint           not null, primary key
#  color      :string
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ControlUnitStatus < ApplicationRecord
  before_save :capitalize_first_letter_of_name

  has_many :control_units, dependent: :nullify

  validates :name, presence: true, uniqueness: true

  scope :for_user, lambda { |user|
    if user.admin?
      all # Devuelve todos los estados si el usuario es administrador
    else
      where.not(name: "Escriturado") # Excluye el estado 'Escriturado' si no es administrador
    end
  }

  def self.libre
    where("name ILIKE ?", "Libre").first
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[color created_at id id_value name updated_at]
  end

  private

  def capitalize_first_letter_of_name
    self.name = name.split.map { |word| word[0].upcase + word[1..] }.join(" ")
  end
end
