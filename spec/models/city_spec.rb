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
require "rails_helper"

RSpec.describe City, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
