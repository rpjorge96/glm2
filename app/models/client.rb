# frozen_string_literal: true

# == Schema Information
#
# Table name: clients
#
#  id                                             :bigint           not null, primary key
#  address                                        :string
#  apellidos                                      :string
#  años_de_vigencia_del_nombramiento              :integer
#  cargo                                          :string
#  cargo_o_puesto                                 :string
#  ciudad                                         :string
#  contact_preference                             :integer
#  correo_electrónico                             :string
#  denominacion_nombre_comercial                  :string
#  departamento_o_estado                          :string
#  dirección                                      :string
#  dirección_de_referencia1                       :string
#  dirección_de_referencia2                       :string
#  domicilio_de_representante_legal               :string
#  dpi                                            :string
#  estado_civil                                   :integer
#  fecha_de_escritura                             :date
#  fecha_de_nacimiento                            :date
#  fecha_vigencia_del_nombramiento                :date
#  folio                                          :string
#  folio_de_nombramiento                          :string
#  género                                         :integer
#  ingresos_mensuales_promedio                    :string
#  libro                                          :string
#  libro_de_nombramiento                          :string
#  lugar_de_escritura                             :string
#  nacionalidad                                   :string
#  nit                                            :string
#  nit_de_representante_legal                     :string
#  no_expediente_y_año                            :string
#  nombre_de_referencia1                          :string
#  nombre_de_referencia2                          :string
#  nombre_empresa_donde_labora                    :string
#  nombres                                        :string
#  notario_autorizante                            :string
#  numero_de_escritura                            :string
#  numero_de_nombramiento                         :string
#  número_de_personas_que_integran_grupo_familiar :integer
#  objeto_actividad_economica                     :string
#  parentesco_de_referencia1                      :string
#  parentesco_de_referencia2                      :string
#  país                                           :string
#  profesión_u_oficio                             :string
#  registro                                       :string
#  teléfono_celular                               :string
#  teléfono_de_referencia1                        :string
#  teléfono_de_referencia2                        :string
#  tiempo_de_laborar                              :string
#  tipo_de_cliente                                :integer
#  tipo_de_entidad                                :string
#  created_at                                     :datetime         not null
#  updated_at                                     :datetime         not null
#  tipo_de_identificacion_cliente_id              :bigint
#
# Indexes
#
#  index_clients_on_tipo_de_identificacion_cliente_id  (tipo_de_identificacion_cliente_id)
#  index_unique_tipo_identificacion_dpi                (tipo_de_identificacion_cliente_id,dpi) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (tipo_de_identificacion_cliente_id => tipo_de_identificacion_clientes.id)
#
class Client < ApplicationRecord
  has_many :quotations
  has_many :control_unit_applicants
  belongs_to :tipo_de_identificacion_cliente
  validates :tipo_de_identificacion_cliente_id,
            presence: { message: "Es requerido seleccionar un tipo de identificacion" }
  validates :tipo_de_identificacion_cliente_id, uniqueness: {scope: :dpi, message: "y numero de identificación deben ser únicos en combinación"}, if: lambda {
    tipo_de_identificacion_cliente_id.present?
  }
  enum tipo_de_cliente: {:Individual => 0, :Jurídico => 1}
  enum estado_civil: {Soltero: 0, Casado: 1, Viudo: 2, Unido: 3, Divorciado: 4}
  enum :género => {Masculino: 0, Femenino: 1}
  enum contact_preference: {:Teléfono => 0, :"Correo electrónico" => 1}

  validates :número_de_personas_que_integran_grupo_familiar,
    numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 9}, allow_blank: true

  validate :fecha_nacimiento_no_puede_ser_futura
  validates :nit, :dpi, uniqueness: {case_sensitive: false, message: "del cliente ya fue ingresado", allow_blank: true}

  def nombre_completo
    "#{nombres} #{apellidos}"
  end

  def name_based_on_client_type
    if tipo_de_cliente == "Individual"
      nombres.present? ? "#{nombres} #{apellidos}" : nil
    elsif tipo_de_cliente == "Jurídico"
      denominacion_nombre_comercial
    end
  end

  def identification_type_based_on_client_type
    if tipo_de_cliente == "Individual"
      tipo_de_identificacion_cliente&.nombre || "Sin identificación"
    elsif tipo_de_cliente == "Jurídico"
      "NIT"
    end
  end

  def identification_number
    if tipo_de_cliente == "Individual"
      dpi.presence || "No encontrado"
    elsif tipo_de_cliente == "Jurídico"
      nit.presence || "No encontrado"
    end
  end

  ransacker :full_name do
    Arel.sql("CONCAT_WS(' ', nombres, apellidos)")
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[full_name dpi nit id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[control_unit_applicants control_units]
  end

  def age # rubocop:disable Metrics/AbcSize
    return unless fecha_de_nacimiento.present?

    today = Date.today
    age = today.year - fecha_de_nacimiento.year

    if today.month < fecha_de_nacimiento.month || (today.month == fecha_de_nacimiento.month && today.day < fecha_de_nacimiento.day) # rubocop:disable Layout/LineLength
      return age - 1
    end
    age
  end

  private

  def fecha_nacimiento_no_puede_ser_futura
    return unless fecha_de_nacimiento.present? && fecha_de_nacimiento > Date.today

    errors.add(:fecha_de_nacimiento, "no puede ser en el futuro")
  end
end
