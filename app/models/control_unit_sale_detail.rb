# == Schema Information
#
# Table name: control_unit_sale_details
#
#  id                           :bigint           not null, primary key
#  annual_interest_rate         :float
#  balance                      :float
#  balcony_area                 :float
#  bank                         :string
#  cash_advance                 :float
#  cash_advance_balance         :float
#  cash_advance_interest_rate   :float
#  construction_area            :float
#  currency                     :string
#  down_payment                 :float
#  estimated_delivery_date      :date
#  file                         :string
#  finance_plan                 :string
#  finance_type                 :integer
#  garden_area                  :float
#  includes_deed_expenses       :boolean
#  installment                  :integer
#  maximum_day                  :integer
#  monthly_installment          :float
#  monthly_payment              :float
#  parking_spaces               :integer
#  parking_type                 :string
#  payment_day                  :integer
#  property_dynamic_fields      :jsonb
#  purchase_date                :date
#  remarks                      :string
#  request_number               :string
#  self_financing_interest_rate :float
#  seller                       :string
#  selling_price                :float
#  term                         :integer
#  total_area                   :float
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  applicant_1_id               :bigint
#  applicant_2_id               :bigint
#  control_unit_id              :bigint           not null
#
# Indexes
#
#  index_control_unit_sale_details_on_applicant_1_id   (applicant_1_id)
#  index_control_unit_sale_details_on_applicant_2_id   (applicant_2_id)
#  index_control_unit_sale_details_on_control_unit_id  (control_unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (applicant_1_id => clients.id)
#  fk_rails_...  (applicant_2_id => clients.id)
#  fk_rails_...  (control_unit_id => control_units.id)
#
class ControlUnitSaleDetail < ApplicationRecord
  MAPPING = {
    # Solicitantes
    "DPI Solicitante 1" => "applicant_1_dpi",
    "NIT Solicitante 1" => "applicant_1_nit",
    "DPI Solicitante 2" => "applicant_2_dpi",
    "NIT Solicitante 2" => "applicant_2_nit",
    # Enganche
    "Valor enganche" => "cash_advance",
    "Pago inicial" => "down_payment",
    "Saldo de" => "cash_advance_balance",
    "Plazo de" => "installment",
    "Cuota mensual de" => "monthly_installment",
    "A mas tardar el día" => "maximum_day",
    "% Interés moratorio" => "cash_advance_interest_rate",
    # Saldo
    "Saldo" => "balance",
    "Banco" => "bank",
    "Expediente" => "file",
    # Financiamiento propio:
    "Plan" => "finance_plan",
    "Plazo" => "term",
    "Día pago" => "payment_day",
    "Cuota mensual" => "monthly_payment",
    "Tasa interés anual" => "annual_interest_rate",
    "% interés moratorio" => "self_financing_interest_rate"
  }.freeze

  attr_accessor :applicant_1_display_text, :applicant_2_display_text

  belongs_to :control_unit

  validate :are_same_applicants, :are_non_existing_applicants
  before_save :set_applicants

  enum finance_type: {"Propio" => 0, "Bancario" => 1, "No aplica" => 2}

  private

  def are_same_applicants
    if !applicant_1_id.nil? && applicant_1_id == applicant_2_id
      errors.add(:applicant_1_id, "no puede ser el mismo cliente que Solicitante 2.")
    end
  end

  def are_non_existing_applicants
    clients = get_clients_display_text

    if applicant_1_display_text != "" && applicant_1_display_text != "N/A" && !clients.include?(applicant_1_display_text)
      errors.add(:applicant_1_display_text, "debe ser un cliente existente.")
    end
    if applicant_2_display_text != "" && applicant_2_display_text != "N/A" && !clients.include?(applicant_2_display_text)
      errors.add(:applicant_2_display_text, "debe ser un cliente existente.")
    end
  end

  def set_applicants
    if applicant_1_display_text == "" || applicant_1_display_text == "N/A"
      self.applicant_1_id = nil
    end
    if applicant_2_display_text == "" || applicant_2_display_text == "N/A"
      self.applicant_2_id = nil
    end
  end

  def get_clients_display_text
    Client.pluck(:tipo_de_cliente, :nombres, :apellidos, :dpi, :denominacion_nombre_comercial, :nit)
      .map { |tipo_de_cliente, nombres, apellidos, dpi, denominacion_nombre_comercial, nit|
      if tipo_de_cliente == "Jurídico"
        nit.present? ? "#{denominacion_nombre_comercial} - #{nit}" : denominacion_nombre_comercial
      else
        dpi.present? ? "#{nombres} #{apellidos} - #{dpi}" : "#{nombres} #{apellidos}"
      end
    }
  end
end
