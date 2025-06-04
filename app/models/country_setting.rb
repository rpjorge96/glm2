# frozen_string_literal: true

# == Schema Information
#
# Table name: country_settings
#
#  id         :bigint           not null, primary key
#  códigos    :string           default([]), is an Array
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class CountrySetting < ApplicationRecord
end
