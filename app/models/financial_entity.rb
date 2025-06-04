# frozen_string_literal: true

# == Schema Information
#
# Table name: financial_entities
#
#  id                                   :bigint           not null, primary key
#  annual_interest_rate                 :decimal(, )
#  down_payment_percentage              :decimal(, )
#  financing_type                       :integer
#  maximum_years_to_finance             :integer
#  minimum_down_payment_cents           :integer
#  minimum_down_payment_currency        :string
#  minimum_down_payment_dollar_cents    :integer
#  minimum_down_payment_dollar_currency :string           default("USD"), not null
#  months_to_pay_down_payment           :integer          default(1)
#  name                                 :string
#  notes                                :jsonb            not null
#  porcentaje_pago_inicial              :decimal(, )
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#
class FinancialEntity < ApplicationRecord
  has_many :quotations

  store_accessor :notes, :note1, :note2

  validates :down_payment_percentage, :annual_interest_rate, :porcentaje_pago_inicial, presence: true
  validates :name,
    presence: true,
    uniqueness: {case_sensitive: false, message: "de entidad financiera ya fue ingresado"}

  validates :down_payment_percentage, :annual_interest_rate,
    numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 100}

  validates :note1, :note2,
    length: {maximum: 500},
    allow_blank: true

  monetize :minimum_down_payment_cents, allow_nil: true
  monetize :minimum_down_payment_dollar_cents, allow_nil: true

  enum financing_type: {cash: 0, financed: 1}

  def note1
    super.presence || ""
  end

  def note2
    super.presence || ""
  end
end
