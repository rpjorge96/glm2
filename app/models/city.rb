# frozen_string_literal: true

# == Schema Information
#
# Table name: cities
#
#  id           :bigint           not null, primary key
#  country_code :string
#  name         :string
#  state_code   :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_cities_on_country_code_and_state_code_and_name  (country_code,state_code,name) UNIQUE
#
class City < ApplicationRecord
  before_save :capitalize_first_letters_of_name

  validates :name,
    uniqueness: {scope: %i[country_code state_code],
                 message: "La ciudad debe ser única dentro de un estado y país"}

  private

  def capitalize_first_letters_of_name
    return if name.blank?

    self.name = name.split.map { |word| word[0].upcase + word[1..] }.join(" ")
  end
end
