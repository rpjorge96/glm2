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
class Role < ApplicationRecord
  has_many :users, dependent: :restrict_with_error
  has_many :permissions, dependent: :destroy

  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :max_allowed_discount_percentage, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :max_days_extend_quotation, :max_days_extend_reservation, presence: true, numericality: {greater_than_or_equal_to: 0}

  def self.ransackable_attributes(_auth_object = nil)
    %w[name]
  end
end
