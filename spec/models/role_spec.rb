# frozen_string_literal: true

# == Schema Information
#
# Table name: roles
#
#  id                              :bigint           not null, primary key
#  max_allowed_discount_percentage :decimal(5, 2)    default(0.0)
#  max_days_extend_quotation       :integer
#  max_days_extend_reservation     :integer
#  name                            :string
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#
require "rails_helper"

RSpec.describe Role, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
