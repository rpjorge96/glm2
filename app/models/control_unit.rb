# frozen_string_literal: true

# == Schema Information
#
# Table name: control_units
#
#  id                                :bigint           not null, primary key
#  altura                            :string
#  area                              :decimal(10, 2)
#  area_desmembracion                :float
#  book_number                       :string
#  code                              :string           not null
#  code_values                       :jsonb
#  description                       :text
#  desmembración_abogado             :string
#  desmembración_fecha_de_escritura  :date
#  desmembración_número_de_escritura :string
#  desmembración_quién_otorga        :string
#  desmembración_quién_recibe        :string
#  discarded_at                      :datetime
#  east_location                     :string
#  finca_number                      :string
#  folio_number                      :string
#  identificacion_registral          :jsonb
#  north_location                    :string
#  plan_approved_at                  :date
#  precio_de_lista_cents             :integer
#  precio_de_lista_currency          :string
#  precio_de_lista_dollar_cents      :integer
#  precio_de_lista_dollar_currency   :string           default("USD"), not null
#  precio_de_venta_cents             :integer
#  precio_de_venta_currency          :string
#  precio_de_venta_dollar_cents      :integer
#  precio_de_venta_dollar_currency   :string           default("USD"), not null
#  predio_number                     :string
#  re_compra_abogado                 :string
#  re_compra_fecha_de_escritura      :date
#  re_compra_número_de_escritura     :string
#  re_compra_quién_otorga            :string
#  re_compra_quién_recibe            :string
#  re_venta_abogado                  :string
#  re_venta_fecha_de_escritura       :date
#  re_venta_número_de_escritura      :string
#  re_venta_quién_otorga             :string
#  re_venta_quién_recibe             :string
#  venta_abogado                     :string
#  venta_fecha_de_escritura          :date
#  venta_número_de_escritura         :string
#  venta_quién_otorga                :string
#  venta_quién_recibe                :string
#  where_is_the_book_from            :string
#  zero_point_location               :integer
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  control_unit_status_id            :bigint
#  control_unit_sub_type_id          :integer
#  control_unit_type_id              :integer
#  finca_id                          :bigint
#  project_id                        :bigint           not null
#
# Indexes
#
#  index_control_units_on_code                    (code) UNIQUE
#  index_control_units_on_control_unit_status_id  (control_unit_status_id)
#  index_control_units_on_discarded_at            (discarded_at)
#  index_control_units_on_finca_id                (finca_id)
#  index_control_units_on_project_id              (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (control_unit_status_id => control_unit_statuses.id)
#  fk_rails_...  (control_unit_sub_type_id => control_unit_sub_types.id)
#  fk_rails_...  (control_unit_type_id => control_unit_types.id)
#  fk_rails_...  (finca_id => fincas.id)
#  fk_rails_...  (project_id => projects.id)
#
class ControlUnit < ApplicationRecord # rubocop:disable Metrics/ClassLength
  MAPPING = {"Código de país" => "country_code",
             "Código de proyecto" => "project_code",
             "Tipo" => "control_unit_type_id",
             "Subtipo" => "control_unit_sub_type",
             "Estado" => "control_unit_status_id",
             "Área (m2)" => "area",
             "Precio de lista(Q)" => "precio_de_lista",
             "Precio de venta(Q)" => "precio_de_venta",
             "Precio de lista($)" => "precio_de_lista_dollar",
             "Precio de venta($)" => "precio_de_venta_dollar",
             "Coordenada del punto cero" => "zero_point_location",
             "Norte (m)" => "north_location",
             "Este (m)" => "east_location",
             "Altura (m)" => "altura",
             # Pending to define
             # 'Finca, folio y libro desmembración' => 'finca_id',
             "Abogado de desmembración" => "desmembración_abogado",
             "Número de escritura de desmembración" => "desmembración_número_de_escritura",
             "Fecha de escritura de desmembración" => "desmembración_fecha_de_escritura",
             "Quién otorga desmembración" => "desmembración_quién_otorga",
             "Quién recibe desmembración" => "desmembración_quién_recibe",
             "Área de desmembración (m2)" => "area_desmembracion",
             "Identificación registral" => "identificacion_registral",
             # 'Número de finca' => 'finca_number',
             # 'Número de folio' => 'folio_number',
             # 'Número de libro' => 'book_number',
             # '¿De dónde es el libro?' => 'where_is_the_book_from',
             "Abogado de venta" => "venta_abogado",
             "Quién otorga venta" => "venta_quién_otorga",
             "Quién recibe venta" => "venta_quién_recibe",
             "Número de escritura de venta" => "venta_número_de_escritura",
             "Fecha de escritura de venta" => "venta_fecha_de_escritura",
             "Abogado de re-venta" => "re_venta_abogado",
             "Quién otorga re-venta" => "re_venta_quién_otorga",
             "Quién recibe re-venta" => "re_venta_quién_recibe",
             "Número de escritura de re-venta" => "re_venta_número_de_escritura",
             "Fecha de escritura de re-venta" => "re_venta_fecha_de_escritura",
             "Número de predio" => "predio_number",
             "Fecha de aprobación de plano" => "plan_approved_at",
             "Notas u observaciones" => "description"}.freeze

  def self.dynamic_mapping(project)
    # Primeros dos valores fijos de MAPPING
    base_mapping = {
      "Código de país" => "country_code",
      "Código de proyecto" => "project_code"
    }

    # Extraer configuración del proyecto (campos activados)
    settings = project.parsed_control_unit_code_settings
    custom_fields = project.custom_control_unit_code_settings.keys

    # Filtrado de sufijos (Se añade solo si "sufijos" está activado)
    suffix_standard = (settings["numero_inicial"] && settings["sufijos"]) ? "Sufijo (Número inicial)" : nil
    suffix_custom = (settings[custom_fields[2]] && settings["sufijos"]) ? "Sufijo (#{custom_fields[2]})" : nil

    # Creación del orden dinámico basado en condiciones
    ordered_fields = []
    ordered_fields << [custom_fields[0], "custom1"] if settings[custom_fields[0]]
    ordered_fields << [custom_fields[1], "custom2"] if settings[custom_fields[1]]
    ordered_fields << ["Número inicial", "numero_inicial"] if settings["numero_inicial"]
    ordered_fields << [suffix_standard, "suffix_standard"] if suffix_standard
    ordered_fields << [custom_fields[2], "custom3"] if settings[custom_fields[2]]
    ordered_fields << [suffix_custom, "suffix_custom"] if suffix_custom

    # Creacion de hash dynamic_fields, eliminacion de valores nulos
    dynamic_fields = ordered_fields.to_h.compact

    # Merge de base, campos dinámicos y el resto de campos fijos
    base_mapping.merge(dynamic_fields).merge({
      "Tipo" => "control_unit_type_id",
      "Subtipo" => "control_unit_sub_type_id",
      "Estado" => "control_unit_status_id",
      "Área (m2)" => "area",
      "Precio de lista(Q)" => "precio_de_lista",
      "Precio de venta(Q)" => "precio_de_venta",
      "Precio de lista($)" => "precio_de_lista_dollar",
      "Precio de venta($)" => "precio_de_venta_dollar",
      "Coordenada del punto cero" => "zero_point_location",
      "Norte (m)" => "north_location",
      "Este (m)" => "east_location",
      "Altura (m)" => "altura",
      # Pending to define
      # 'Finca, folio y libro desmembración' => 'finca_id',
      "Abogado de desmembración" => "desmembración_abogado",
      "Número de escritura de desmembración" => "desmembración_número_de_escritura",
      "Fecha de escritura de desmembración" => "desmembración_fecha_de_escritura",
      "Quién otorga desmembración" => "desmembración_quién_otorga",
      "Quién recibe desmembración" => "desmembración_quién_recibe",
      "Área de desmembración (m2)" => "area_desmembracion",
      "Abogado de venta" => "venta_abogado",
      "Quién otorga venta" => "venta_quién_otorga",
      "Quién recibe venta" => "venta_quién_recibe",
      "Número de escritura de venta" => "venta_número_de_escritura",
      "Fecha de escritura de venta" => "venta_fecha_de_escritura",
      "Abogado de re-venta" => "re_venta_abogado",
      "Quién otorga re-venta" => "re_venta_quién_otorga",
      "Quién recibe re-venta" => "re_venta_quién_recibe",
      "Número de escritura de re-venta" => "re_venta_número_de_escritura",
      "Fecha de escritura de re-venta" => "re_venta_fecha_de_escritura",
      "Número de predio" => "predio_number",
      "Fecha de aprobación de plano" => "plan_approved_at",
      "Notas u observaciones" => "description"
    })
  end

  CUSTOM_GROUP_ACTIONS = ["Código", "Datos Base", "Topografía", "Desmembración", "Identificación Registral", "Venta",
    "Re-Compra", "Re-Venta", "Datos Ric", "Adjuntos", "Notas u observaciones"].freeze
  DESIGN_PARAMS = %i[code control_unit_type_id control_unit_status_id zero_point_location area north_location
    east_location altura].freeze
  LEGAL_PARAMS = %i[finca_number folio_number book_number where_is_the_book_from
    predio_number plan_approved_at
    desmembración_abogado desmembración_fecha_de_escritura desmembración_número_de_escritura
    desmembración_quién_otorga desmembración_quién_recibe venta_abogado
    venta_fecha_de_escritura venta_número_de_escritura
    venta_quién_otorga venta_quién_recibe finca_id area_desmembracion].freeze

  include Discard::Model

  attr_accessor :is_admin, :user_role

  before_validation :generate_code
  # after_initialize :set_default_code, if: :new_record?
  belongs_to :project
  belongs_to :control_unit_status, optional: true
  belongs_to :control_unit_type, optional: true
  belongs_to :control_unit_sub_type, optional: true
  belongs_to :finca, optional: true

  belongs_to :sub_type,
    primary_key: "id",
    foreign_key: "control_unit_sub_type_id",
    class_name: "ControlUnitSubType",
    optional: true
  belongs_to :type,
    primary_key: "id",
    foreign_key: "control_unit_type_id",
    class_name: "ControlUnitType",
    optional: true

  has_one :control_unit_sale_detail, dependent: :destroy
  has_one :control_unit_payment_detail, dependent: :destroy
  has_many :control_unit_applicants, dependent: :destroy
  has_many :boundaries, dependent: :destroy
  has_many :listado_de_precios, dependent: :destroy
  has_one_attached :plan
  has_one_attached :derrotero
  has_one_attached :otro

  accepts_nested_attributes_for :control_unit_sale_detail, allow_destroy: true
  accepts_nested_attributes_for :control_unit_payment_detail, allow_destroy: true
  accepts_nested_attributes_for :boundaries, allow_destroy: true

  validates :code, presence: true, uniqueness: true
  validates :control_unit_type_id, presence: true

  validate :control_unit_code_validation
  validate :code_update_permission, on: :update
  # validate :permitted_params_by_role
  validate :areas_validation
  validate :formato_de_fechas

  monetize :precio_de_lista_cents, allow_nil: true
  monetize :precio_de_venta_cents, allow_nil: true
  monetize :precio_de_lista_dollar_cents, allow_nil: true
  monetize :precio_de_venta_dollar_cents, allow_nil: true

  enum zero_point_location: {GTM: 0, UTM: 1}

  # it seems this ordering is not the expected one
  # default_scope do
  #   order(manzana_edificio: :asc, sector_nivel: :asc, número_inicial: :asc, numero_inicial_suffix: :asc,
  #         número_final: :asc, numero_final_suffix: :asc)
  # end

  scope :libres, lambda {
    joins(:control_unit_status).where("control_unit_statuses.name ILIKE ?", "Libre")
  }

  # default_scope { where(project.kept) }
  def self.custom_numero_identificacion(n_inicial, n_final, n_inicial_suffix, n_final_suffix)
    numero = []
    numero << n_inicial.to_s.rjust(3, "0").to_s if n_inicial.present?
    numero << "-#{n_inicial_suffix}" if n_inicial_suffix.present?
    numero << "-#{n_final.to_s.rjust(3, "0")}"
    numero << "-#{n_final_suffix}" if n_final_suffix.present?

    numero.join
  end

  def self.localized_attributes
    attribute_names.map do |attribute_name|
      [I18n.t("activerecord.attributes.#{model_name.i18n_key}.#{attribute_name}"), attribute_name]
    end
  end

  ransacker :precio_de_lista_cents do
    # cast to string
    Arel.sql("CAST(precio_de_lista_cents AS VARCHAR)")
  end

  def get_dynamic_fields_str
    fields = []
    project.custom_control_unit_code_settings.each_with_index do |(key, value), index|
      next unless value && code_values[key].present? && index != 2
      fields << "#{key}: #{code_values[key].rjust(1, "0")}"
    end

    project.standard_control_unit_code_settings.each do |key, value|
      next unless value && code_values[key].present? && key == "numero_inicial" && code_values["suffix_standard"].present?
      fields << "Número inicial: #{code_values[key].rjust(3, "0")}"
      if project.control_unit_code_settings_suffix_enabled?
        fields << "Sufijo: #{code_values["suffix_standard"]}"
      end
    end

    project.custom_control_unit_code_settings.each_with_index do |(key, value), index|
      next unless value && code_values[key].present? && index == 2
      fields << "#{key}: #{code_values[key].rjust(3, "0")}"

      if project.control_unit_code_settings_suffix_enabled? && code_values["suffix_custom"].present?
        fields << "Sufijo: #{code_values["suffix_custom"]}"
      end
    end

    fields.join(" - ")
  end

  def self.import_create(file, user_role, project)
    spreadsheet = Roo::Spreadsheet.open(file.path)
    header = spreadsheet.row(1)
    errors = []
    imported_count = 0
    not_imported_count = 0

    # Map de atributos segun project + atributos de ControlUnitSaleDetail
    mapping = dynamic_mapping(project).merge(ControlUnitSaleDetail::MAPPING)
    ignored_fields = %w[custom1 custom2 numero_inicial suffix_standard custom3 suffix_custom]

    (2..spreadsheet.last_row).each do |i|
      row_data = spreadsheet.row(i)
      row = header.zip(row_data).to_h

      # Mapeo general de atributos en Excel
      mapped_attributes = row.transform_keys { |key| mapping[key] || key }

      # Selección de atributos para cada objeto
      control_unit_attributes = mapped_attributes.except(*ignored_fields, *ControlUnitSaleDetail::MAPPING.values)
      sale_detail_attributes = mapped_attributes.slice(*ControlUnitSaleDetail::MAPPING.values).except("applicant_1_dpi", "applicant_1_nit", "applicant_2_dpi", "applicant_2_nit")

      suffix_standard = mapped_attributes["suffix_standard"]
      suffix_custom = mapped_attributes["suffix_custom"]

      # Code values
      parsed = project.parsed_control_unit_code_settings
      dm = dynamic_mapping(project)       # 'Dynamic field label' => internal_key
      custom_mapping = project.custom_control_unit_code_settings
      standard_mapping = project.standard_control_unit_code_settings

      code_values = {}

      %w[sufijos re_compra re_venta].each do |flag|
        code_values[flag] = true if parsed[flag]
      end

      custom_mapping.each do |label, enabled|
        next unless enabled
        internal = dm[label]
        raw = mapped_attributes[internal].to_s
        width = if internal == "custom2"
          2
        else
          ((internal == "custom3") ? 3 : 1)
        end
        code_values[label] = raw.rjust(width, "0")
      end

      if standard_mapping["numero_inicial"]
        code_values["numero_inicial"] = mapped_attributes["numero_inicial"].to_s.rjust(3, "0")
      end

      if parsed["sufijos"] && standard_mapping["numero_inicial"]
        code_values["suffix_standard"] = suffix_standard.to_s if suffix_standard.present?
      end

      third_label = custom_mapping.keys[2]
      if parsed["sufijos"] && custom_mapping[third_label]
        code_values["suffix_custom"] = suffix_custom.to_s if suffix_custom.present?
      end

      control_unit_attributes["code_values"] = code_values

      # Asignacion de status_id para control_unit_attributes, segun busqueda por nombre (name:)
      status = ControlUnitStatus.find_by(name: control_unit_attributes["control_unit_status_id"])
      raise ArgumentError, "Estado '#{control_unit_attributes["control_unit_status_id"]}' no encontrado." unless status
      control_unit_attributes["control_unit_status_id"] = status.id

      control_unit_type = ControlUnitType.find_by(name: control_unit_attributes["control_unit_type_id"])
      unless control_unit_type
        raise ArgumentError, "Tipo de unidad de control '#{control_unit_attributes["control_unit_type_id"]}' no encontrado."
      end

      control_unit_attributes["control_unit_type_id"] = control_unit_type.id

      control_unit = new(user_role:)

      # Asignacion de sub_type_id para control_unit_attributes, segun busqueda por nombre (name:)
      if control_unit_attributes["control_unit_sub_type_id"].present?
        sub_type_label = control_unit_attributes["control_unit_sub_type_id"].to_s.strip
        control_unit_sub_type = control_unit_type
          .control_unit_sub_types
          .for_project(control_unit.project_id)
          .find_by(name: sub_type_label)
        if control_unit_sub_type.present?
          control_unit_attributes["control_unit_sub_type_id"] = control_unit_sub_type.id
        else
          raise ArgumentError, "Subtipo de unidad de control '#{sub_type_label}' no encontrado para este proyecto y tipo: '#{control_unit_type.id}'."
        end
      end

      unless control_unit.project.country_code == control_unit_attributes["country_code"]
        raise ArgumentError, "El código de país '#{control_unit_attributes["country_code"]}' no coincide con el proyecto."
      end

      unless control_unit.project.two_digits_code == control_unit_attributes["project_code"].to_s.strip
        raise ArgumentError, "El código de proyecto '#{control_unit_attributes["project_code"]}' no coincide con el proyecto."
      end

      finca_id = control_unit.project.fincas.find_by_codigo(control_unit_attributes["finca_folio_libro"])
      control_unit_attributes["finca_id"] = finca_id

      control_unit_attributes.delete("country_code")
      control_unit_attributes.delete("project_code")

      control_unit.attributes = control_unit_attributes

      control_unit.save
      if control_unit.persisted?
        imported_count += 1
      else
        not_imported_count += 1
        errors << ["Fila #{i}", control_unit.errors.full_messages]
      end

      begin
        # Manejo de applicant_1_id
        if mapped_attributes["applicant_1_dpi"].present? || mapped_attributes["applicant_1_nit"].present?
          applicant_1 = Client.find_by(dpi: mapped_attributes["applicant_1_dpi"]) || Client.find_by(nit: mapped_attributes["applicant_1_nit"])
          sale_detail_attributes["applicant_1_id"] = applicant_1&.id
        end

        # Manejo de applicant_2_id
        if mapped_attributes["applicant_2_dpi"].present? || mapped_attributes["applicant_2_nit"].present?
          applicant_2 = Client.find_by(dpi: mapped_attributes["applicant_2_dpi"]) || Client.find_by(nit: mapped_attributes["applicant_2_nit"])
          sale_detail_attributes["applicant_2_id"] = applicant_2&.id
        end

        sale_detail_attributes["control_unit_id"] = ControlUnit.find_by(code: control_unit_attributes["code"]).id

        sale_detail = ControlUnitSaleDetail.new(sale_detail_attributes)

        # Creacion de ControlUnitSaleDetail
        next if applicant_1.nil? && applicant_2.nil?

        if sale_detail.valid?
          sale_detail.save
        else
          raise ArgumentError, "Error en ControlUnitSaleDetail: #{sale_detail.errors.full_messages.join(",")}"
        end

        # Creacion de Applicants
        applicant_1 = ControlUnitApplicant.find_or_create_by(
          control_unit_id: sale_detail_attributes["control_unit_id"],
          applicant_type: 0
        ) do |applicant|
          applicant.client_id = sale_detail_attributes["applicant_1_id"]
        end

        applicant_1.update(client_id: sale_detail_attributes["applicant_1_id"]) if applicant_1.client_id != sale_detail_attributes["applicant_1_id"]

        applicant_2 = ControlUnitApplicant.find_or_create_by(
          control_unit_id: sale_detail_attributes["control_unit_id"],
          applicant_type: 1
        ) do |applicant|
          applicant.client_id = sale_detail_attributes["applicant_2_id"]
        end

        applicant_2.update(client_id: sale_detail_attributes["applicant_2_id"]) if applicant_2.client_id != sale_detail_attributes["applicant_2_id"]
      rescue ArgumentError => e
        errors << ["Fila #{i}", e.message]
      rescue => e
        errors << ["Fila #{i}", "Error inesperado: #{e.message}"]
      end
    end

    {
      cantidad_importados: imported_count,
      cantidad_no_importados: not_imported_count,
      total_procesados: imported_count + not_imported_count,
      errores: errors
    }
  end

  def self.import_update(file, user_role, project)
    spreadsheet = Roo::Spreadsheet.open(file.path)
    header = spreadsheet.row(1)
    errors = []
    imported_count = 0
    not_imported_count = 0

    # Map de atributos segun project + atributos de ControlUnitSaleDetail
    mapping = dynamic_mapping(project).merge(ControlUnitSaleDetail::MAPPING)
    ignored_fields = %w[custom1 custom2 numero_inicial suffix_standard custom3 suffix_custom]

    (2..spreadsheet.last_row).each do |i|
      row_data = spreadsheet.row(i)
      row = header.zip(row_data).to_h

      # Mapeo general de atributos en Excel
      mapped_attributes = row.transform_keys { |key| mapping[key] || key }

      # Selección de atributos para cada objeto
      control_unit_attributes = mapped_attributes.except(*ignored_fields, *ControlUnitSaleDetail::MAPPING.values)
      sale_detail_attributes = mapped_attributes.slice(*ControlUnitSaleDetail::MAPPING.values).except("applicant_1_dpi", "applicant_1_nit", "applicant_2_dpi", "applicant_2_nit")

      control_unit_attributes.compact_blank!
      sale_detail_attributes.compact_blank!

      # Asignacion de type_id para control_unit_attributes, segun busqueda por nombre (name:)
      tipo_val = mapped_attributes["control_unit_type_id"].to_s.strip
      if tipo_val.blank?
        control_unit_attributes.delete("control_unit_type_id")
      else
        tipo_val = tipo_val.capitalize
        control_unit_type = ControlUnitType.find_by(name: tipo_val)
        raise ArgumentError, "Tipo de unidad de control '#{tipo_val}' no encontrado." unless control_unit_type
        control_unit_attributes["control_unit_type_id"] = control_unit_type.id
      end

      # Asignacion de status_id para control_unit_attributes, segun busqueda por nombre (name:)
      status = ControlUnitStatus.find_by(name: mapped_attributes["control_unit_status_id"])
      raise ArgumentError, "Estado '#{mapped_attributes["control_unit_status_id"]}' no encontrado." unless status
      control_unit_attributes["control_unit_status_id"] = status.id

      # Creacion de :code para ControlUnit
      formatted_code = [
        project.country_code,
        project.two_digits_code.to_s.rjust(2, "0"),
        mapped_attributes["custom1"].presence,
        (mapped_attributes["custom2"].present? ? mapped_attributes["custom2"].to_s.rjust(2, "0") : nil),
        (mapped_attributes["numero_inicial"].present? ? mapped_attributes["numero_inicial"].to_s.rjust(3, "0") : nil),
        mapped_attributes["suffix_standard"].presence,
        (mapped_attributes["custom3"].present? ? mapped_attributes["custom3"].to_s.rjust(3, "0") : nil),
        mapped_attributes["suffix_custom"].presence
      ].reject(&:blank?).join("-")

      # Busqueda de ControlUnit con :code generado
      control_unit = find_by(code: formatted_code)
      raise ArgumentError, "Unidad de control '#{formatted_code}' no encontrada." unless control_unit

      control_unit.user_role = user_role

      # Asignacion de sub_type_id para control_unit_attributes, segun busqueda por nombre (name:)
      if mapped_attributes["control_unit_sub_type_id"].present?
        sub_type_label = mapped_attributes["control_unit_sub_type_id"].to_s.strip
        if sub_type_label == "0"
          control_unit_attributes.delete("control_unit_sub_type_id")
        else
          control_unit_sub_type = control_unit_type
            .control_unit_sub_types
            .for_project(control_unit.project_id)
            .find_by(name: sub_type_label)
          if control_unit_sub_type.present?
            control_unit_attributes["control_unit_sub_type_id"] = control_unit_sub_type.id
          else
            raise ArgumentError, "Subtipo de unidad de control '#{sub_type_label}' no encontrado para este proyecto y tipo: '#{control_unit_type.id}'."
          end
        end
      end

      unless control_unit.project.country_code == mapped_attributes["country_code"]
        raise ArgumentError, "El código de país '#{mapped_attributes["country_code"]}' no coincide con el proyecto."
      end

      unless control_unit.project.two_digits_code == mapped_attributes["project_code"].to_s.strip
        raise ArgumentError, "El código de proyecto '#{mapped_attributes["project_code"]}' no coincide con el proyecto."
      end

      finca_id = control_unit.project.fincas.find_by_codigo(mapped_attributes["finca_folio_libro"])
      control_unit_attributes["finca_id"] = finca_id

      control_unit_attributes.delete("country_code")
      control_unit_attributes.delete("project_code")

      control_unit.attributes = control_unit_attributes
      control_unit.save

      if control_unit.persisted? && control_unit.errors.empty?
        imported_count += 1
      else
        not_imported_count += 1
        errors << ["Fila #{i}", control_unit.errors.full_messages]
      end
      # ---- Actualizar o Crear ControlUnitSaleDetail ----
      begin
        sale_detail = ControlUnitSaleDetail.find_or_create_by(control_unit_id: control_unit.id)

        # Manejo de applicant_1_id
        if mapped_attributes["applicant_1_dpi"].present? || mapped_attributes["applicant_1_nit"].present?
          applicant_1 = Client.find_by(dpi: mapped_attributes["applicant_1_dpi"]) || Client.find_by(nit: mapped_attributes["applicant_1_nit"])
          sale_detail_attributes["applicant_1_id"] = applicant_1&.id
        end

        # Manejo de applicant_2_id
        if mapped_attributes["applicant_2_dpi"].present? || mapped_attributes["applicant_2_nit"].present?
          applicant_2 = Client.find_by(dpi: mapped_attributes["applicant_2_dpi"]) || Client.find_by(nit: mapped_attributes["applicant_2_nit"])
          sale_detail_attributes["applicant_2_id"] = applicant_2&.id
        end

        # Filtrado de atributos para ControlUnitSaleDetail object
        sale_detail_attributes = sale_detail_attributes.except("applicant_1_dpi", "applicant_1_nit", "applicant_2_dpi", "applicant_2_nit")
        sale_detail_attributes.compact_blank!

        sale_detail.update!(sale_detail_attributes)
        sale_detail.reload

        # Update de Applicants
        applicant_1 = ControlUnitApplicant.find_or_create_by(
          control_unit_id: sale_detail_attributes["control_unit_id"],
          applicant_type: 0
        ) do |applicant|
          applicant.client_id = sale_detail_attributes["applicant_1_id"]
        end

        applicant_1.update(client_id: sale_detail_attributes["applicant_1_id"]) if applicant_1.client_id != sale_detail_attributes["applicant_1_id"]

        applicant_2 = ControlUnitApplicant.find_or_create_by(
          control_unit_id: sale_detail_attributes["control_unit_id"],
          applicant_type: 1
        ) do |applicant|
          applicant.client_id = sale_detail_attributes["applicant_2_id"]
        end

        applicant_2.update(client_id: sale_detail_attributes["applicant_2_id"]) if applicant_2.client_id != sale_detail_attributes["applicant_2_id"]
      rescue ActiveRecord::RecordInvalid => e
        not_imported_count += 1
        errors << ["Fila #{i}", "Error actualizando ControlUnitSaleDetail: #{e.message}"]
      rescue => e
        not_imported_count += 1
        errors << ["Fila #{i}", "Error inesperado en ControlUnitSaleDetail: #{e.message}"]
      end
    rescue ArgumentError => e
      not_imported_count += 1
      errors << ["Fila #{i}", e.message]
    rescue => e
      not_imported_count += 1
      errors << ["Fila #{i}", "Error inesperado: #{e.message}"]
    end
    {
      cantidad_importados: imported_count,
      cantidad_no_importados: not_imported_count,
      total_procesados: imported_count + not_imported_count,
      errores: errors
    }
  end

  def country_code
    project.country_code
  end

  def project_code
    project.code
  end

  def calculate_code
    code_calculated = project.code_with_country.to_s
    code_calculated += "-#{manzana_edificio}" if manzana_edificio.present?
    code_calculated += "-#{sector_nivel}" if sector_nivel.present?
    code_calculated += "-#{número_inicial.to_s.rjust(3, "0")}" if número_inicial.present?
    code_calculated += "-#{numero_inicial_suffix}" if numero_inicial_suffix.present?
    code_calculated += "-#{número_final.to_s.rjust(3, "0")}"
    code_calculated += "-#{numero_final_suffix}" if numero_final_suffix.present?
    code_calculated
  end

  def extras
    sub_type_projects = ControlUnitSubTypeProject.where(project_id:, control_unit_sub_type_id: sub_type&.id)
    sub_type_projects.map(&:extras).flatten
  end

  def all_available_extras
    (Extra.for_project_and_control_unit_type(project.id, control_unit_type_id) + extras).uniq
  end

  def numero_identificacion # rubocop:disable Metrics/AbcSize
    numero_parts = []
    numero_parts << formatted_numero_inicial if número_inicial.present?
    numero_parts << numero_inicial_suffix if numero_inicial_suffix.present?
    numero_parts << formatted_numero_final if número_final.present?
    numero_parts << numero_final_suffix if numero_final_suffix.present?

    numero_parts.any? ? numero_parts.join("-") : nil
  end

  def pdf_sector_nivel
    sector_nivel.to_i.to_s
  end

  def searchable_dropdown_config(applicant_number = 1)
    {label: "Solicitante #{applicant_number}", display_column: "display_text", placeholder: "Nombre o Número de identificación"}
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[code control_unit_type_id control_unit_sub_type_id control_unit_status_id precio_de_lista_cents id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[control_unit_type control_unit_sub_type control_unit_status]
  end

  private

  def formatted_numero_inicial
    número_inicial.to_s.rjust(3, "0")
  end

  def formatted_numero_final
    número_final.to_s.rjust(3, "0")
  end

  def set_default_code
    self.code ||= "#{project.country_code}-#{project.two_digits_code}-"
  end

  def generate_code
    code = project.code_with_country.to_s

    project.custom_control_unit_code_settings.each_with_index do |(key, value), index|
      next unless value && code_values[key].present? && index != 2

      code += "-#{code_values[key].rjust(1, "0")}"
    end

    project.standard_control_unit_code_settings.each do |key, value|
      next unless value && code_values[key].present?

      code += "-#{code_values[key].rjust(3, "0")}"
      code += "-#{code_values["suffix_standard"]}" if key == "numero_inicial" && code_values["suffix_standard"].present?
    end

    project.custom_control_unit_code_settings.each_with_index do |(key, value), index|
      next unless value && code_values[key].present? && index == 2

      code += "-#{code_values[key].rjust(3, "0")}"
      code += "-#{code_values["suffix_custom"]}" if code_values["suffix_custom"].present?
    end

    self.code = code
  end

  # def capitalize_first_letter_of_notary
  #   return if notary.blank?

  #   self.notary = notary.split.map { |word| word[0].upcase + word[1..] }.join(' ')
  # end

  def control_unit_code_validation
    # Construye el prefijo esperado
    prefijo_esperado = "#{project.country_code}-#{project.two_digits_code}"

    # Verifica si el atributo comienza con el prefijo
    return if code&.start_with?(prefijo_esperado)

    errors.add(:code, "para este proyecto debe comenzar con el formato '#{prefijo_esperado}'")
  end

  def code_update_permission
    return unless (code_changed? && !is_admin) || (code_changed? && user_role != "admin") # standard:disable Style/UnlessLogicalOperators

    errors.add(:code, "no se puede modificar")
  end

  def permitted_params_by_role
    return if user_role == "admin"

    errors.add(:user_role, "no tiene permiso para realizar esta acción") unless %W[dise\u00F1o
      legal].include?(user_role)
    case user_role
    when "diseño"
      unpermitted_changes = changes.keys.map(&:to_sym) - DESIGN_PARAMS

      unpermitted_changes.each do |field|
        errors.add(field, "cambio no permitido")
      end
    when "legal"
      unpermitted_changes = changes.keys.map(&:to_sym) - LEGAL_PARAMS

      unpermitted_changes.each do |field|
        errors.add(field, "cambio no permitido")
      end
    end
  end

  def areas_validation
    return if area.blank? || area_desmembracion.blank?
    return unless area.to_i != area_desmembracion.to_i

    errors.add(:base, "Los valores enteros de área y área de desmembración deben coincidir.")
  end

  def formato_de_fechas
    %I[desmembraci\u00F3n_fecha_de_escritura venta_fecha_de_escritura re_venta_fecha_de_escritura
      plan_approved_at].each do |fecha|
      unless send(fecha).blank? || send(fecha).is_a?(Date) || send(fecha).is_a?(Time)
        errors.add(fecha,
          "debe ser una fecha válida")
      end
    end
  end
end
