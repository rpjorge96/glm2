# frozen_string_literal: true

# == Schema Information
#
# Table name: quotations
#
#  id                  :bigint           not null, primary key
#  client_email        :string
#  client_name         :string
#  client_phone        :string
#  down_payment_months :integer
#  pdf_generated_at    :datetime
#  quotation_params    :jsonb
#  reference_number    :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  client_id           :integer
#
class Quotation < ApplicationRecord
  include QuotationPdfHelper
  belongs_to :client, optional: true
  has_one :discount_authorization, dependent: :destroy
  validates :reference_number, presence: true, uniqueness: true
  after_initialize :generate_reference_number, if: :new_record?

  delegate :project, to: :control_unit_object, allow_nil: true
  delegate :name, to: :last_edited_by, prefix: true, allow_nil: true

  has_one_attached :pdf

  def control_unit
    parsed_params["control_units"]&.first
  end

  def control_unit_object
    if custom_house?
      ControlUnit.find_by(code: lots.first["code"])
    else
      ControlUnit.find_by(id: control_unit&.dig("id"))
    end
  end

  def parsed_params
    return {} if quotation_params.nil?

    begin
      JSON.parse(quotation_params)
    rescue JSON::ParserError
      {}
    end
  end

  def total_price
    control_unit.precio_de_lista.to_f
  end

  def down_payment
    total_price * financial_entity.down_payment_percentage / 100
  end

  def years_to_finance
    parsed_params["years_to_finance"]
  end

  def financial_entities
    parsed_params["financial_entities"]
  end

  def financing_type
    return nil if financial_entities.nil? || financial_entities.empty?

    financial_entities.first["financing_type"]
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[client_name reference_number]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[]
  end

  def custom_house?
    control_unit&.dig("is_custom_house") || false
  end

  def lots
    control_unit["lots"]
  end

  def generate_pdf
    return if pdf.attached?

    GenerateQuotationPdf.new(self).call
  end

  def purge_pdf
    pdf.purge if pdf.attached?
  end

  private

  def generate_reference_number
    return if reference_number.present?

    current_year_month = Time.now.strftime("%m-%y-")
    internal_code = project&.internal_code || "ABC"

    last_reference_number = Quotation.where("reference_number LIKE ?", "#{internal_code}-#{current_year_month}%")
      .order(reference_number: :desc)
      .pluck(:reference_number)
      .first

    new_correlative = if last_reference_number.present?
      last_correlative = last_reference_number.split("-").last.to_i
      last_correlative + 1
    else
      1
    end

    self.reference_number = "#{internal_code}-#{current_year_month}#{new_correlative.to_s.rjust(4, "0")}"
  end
end
