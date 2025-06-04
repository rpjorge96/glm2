class SaleRequestText
  attr_reader :quotation, :client1, :client2, :text, :preview

  # Project variables
  delegate :project, to: :quotation
  delegate :name, to: :project, prefix: true
  # ControlUnitSubType variables
  delegate :control_unit_sub_type, to: :quotation
  delegate :name, to: :control_unit_sub_type, prefix: true
  delegate :garden_area, to: :control_unit_sub_type, prefix: true
  delegate :balconies_terrace_area, to: :control_unit_sub_type, prefix: true
  delegate :parking_spaces, to: :control_unit_sub_type, prefix: true
  delegate :parking_type, to: :control_unit_sub_type, prefix: true
  delegate :subtype_variable_data, to: :control_unit_sub_type, prefix: true
  delegate :control_unit_object_code_values, to: :quotation
  delegate :total_construction_area, to: :quotation
  delegate :calculated_values, to: :quotation
  delegate :format_as_currency, to: :quotation
  delegate :control_unit_object_code, to: :quotation
  delegate :active_maintenance_fee, to: :quotation
  delegate :passive_maintenance_fee, to: :quotation
  delegate :nombres, :apellidos, :identification_type_based_on_client_type, :identification_number, :estado_civil, :age,
    :nit, :nacionalidad, :teléfono_celular, :contact_preference, :profesión_u_oficio, :correo_electrónico, :dirección,
    :ciudad, :departamento_o_estado, :país, to: :client1, prefix: true
  delegate :nombres, :apellidos, :identification_type_based_on_client_type, :identification_number, :estado_civil, :age,
    :nit, :nacionalidad, :teléfono_celular, :contact_preference, :profesión_u_oficio, :correo_electrónico, :dirección,
    :ciudad, :departamento_o_estado, :país, to: :client2, prefix: true

  def initialize(text, quotation: nil, client1: nil, client2: nil, preview: false)
    @quotation = quotation
    @client1 = client1
    @client2 = client2
    @text = text
    @preview = preview
  end

  def call
    text_variables = @preview ? test_variables : variables

    @text.gsub(/@@(\w+)/) do |match|
      key = $1
      text_variables[key] || match
    end
  end

  private

  def variables
    {
      "codigo_unidad_de_control" => control_unit_object_code,
      "proyecto" => project_name,
      "nombre_dinamico_1" => code_data_to_array&.dig(0, 0),
      "nombre_dinamico_2" => code_data_to_array&.dig(1, 0),
      "nombre_dinamico_3" => code_data_to_array&.dig(2, 0),
      "valor_dinamico_1" => code_data_to_array&.dig(0, 1),
      "valor_dinamico_2" => code_data_to_array&.dig(1, 1),
      "valor_dinamico_3" => code_data_to_array&.dig(2, 1),
      "numero_inicial" => initial_number_value,
      "subtipo" => control_unit_sub_type_name,
      "area_construccion" => total_construction_area,
      "area_jardin" => control_unit_sub_type_garden_area,
      "area_balcones_terraza" => control_unit_sub_type_balconies_terrace_area,
      "cantidad_parqueos" => control_unit_sub_type_parking_spaces,
      "tipo_parqueo" => control_unit_sub_type_parking_type,
      "total_extra" => format_as_currency(calculated_values["extrasTotal"]),
      "pago_total_enganche" => format_as_currency(financial_entity_calculated_values["downPayment"]),
      "valor_total" => format_as_currency(calculated_values["priceAfterDiscount"]),
      "meses_para_enganche" => months_for_down_payment,
      "aporte_inicial" => format_as_currency(financial_entity_calculated_values["initialPayment"]),
      "cuota_enganche" => format_as_currency(financial_entity_calculated_values["monthlyDownPayment"]),
      "saldo_financiar" => format_as_currency(financial_entity_calculated_values["toFinance"]),
      "tasa_anual" => format("%.2f", financial_entity["annual_interest_rate"].to_f),
      "cuota_mantenimiento_activa" => active_maintenance_fee,
      "cuota_mantenimiento_pasiva" => passive_maintenance_fee,
      "lugar_fecha" => "Guatemala, #{I18n.l(Date.today, format: :long)}",
      "nombre_vendedor" => "Pepito Pérez"
    }
      .merge(subtype_extra_variables)
      .merge(client_info(client1, 1))
      .merge(client_info(client2, 2))
  end

  def client_info(client, id)
    label = "aplicante_#{id}"

    {
      "nombres_#{label}" => client.nombres,
      "apellidos_#{label}" => client.apellidos,
      "tipo_id_#{label}" => client.identification_type_based_on_client_type,
      "numero_id_#{label}" => client.identification_number,
      "edad_#{label}" => client.age,
      "estado_civil_#{label}" => client.estado_civil,
      "nacionalidad_#{label}" => client.nacionalidad,
      "profesion_#{label}" => client.profesión_u_oficio,
      "telefono_#{label}" => client.teléfono_celular,
      "preferencia_contacto_#{label}" => client.contact_preference,
      "nit_#{label}" => client.nit,
      "correo_#{label}" => client.correo_electrónico,
      "direccion_#{label}" => client.dirección,
      "ciudad_#{label}" => client.ciudad,
      "departamento_#{label}" => client.departamento_o_estado,
      "pais_#{label}" => client.país,
      "empresa_labora_#{label}" => client.nombre_empresa_donde_labora,
      "direccion_empresa_#{label}" => client.address,
      "cargo_#{label}" => client.cargo_o_puesto,
      "tiempo_laborar_#{label}" => client.tiempo_de_laborar,
      "ingresos_#{label}" => client.ingresos_mensuales_promedio,
      "nombre_referencia_1_#{label}" => client.nombre_de_referencia1,
      "parentesco_referencia_1_#{label}" => client.parentesco_de_referencia1,
      "direccion_referencia_1_#{label}" => client.dirección_de_referencia1,
      "telefono_referencia_1_#{label}" => client.teléfono_de_referencia1,
      "nombre_referencia_2_#{label}" => client.nombre_de_referencia2,
      "parentesco_referencia_2_#{label}" => client.parentesco_de_referencia2,
      "direccion_referencia_2_#{label}" => client.dirección_de_referencia2,
      "telefono_referencia_2_#{label}" => client.teléfono_de_referencia2
    }
  end

  def financial_entity_calculated_values
    calculated_values.values.first
  end

  def financial_entity
    quotation.financial_entities.first
  end

  def code_data_to_array
    quotation.code_data.to_a
  end

  def months_for_down_payment
    financial_entity_calculated_values["monthsToPayDownPayment"] || financial_entity_calculated_values["finalMonthsToCession"]
  end

  def initial_number_value
    initial_number = control_unit_object_code_values.dig("numero_inicial")
    suffix = control_unit_object_code_values.dig("sufix_standard")
    "#{initial_number}#{suffix}"
  end

  def test_variables
    {
      "codigo_unidad_de_control" => "Codigo Unidad de Control",
      "proyecto" => "Proyecto",
      "nombre_dinamico_1" => "Nombre Dinamico 1",
      "nombre_dinamico_2" => "Nombre Dinamico 2",
      "nombre_dinamico_3" => "Nombre Dinamico 3",
      "valor_dinamico_1" => "Valor Dinamico 1",
      "valor_dinamico_2" => "Valor Dinamico 2",
      "valor_dinamico_3" => "Valor Dinamico 3",
      "numero_inicial" => "Numero Inicial",
      "subtipo" => "Subtipo",
      "area_construccion" => "Area Construccion",
      "area_jardin" => "Area Jardin",
      "area_balcones_terraza" => "Area Balcones Terraza",
      "cantidad_parqueos" => "Cantidad Parqueos",
      "tipo_parqueo" => "Tipo Parqueo",
      "total_extra" => "Total Extra",
      "pago_total_enganche" => "Pago Total Enganche",
      "valor_total" => "Valor Total",
      "meses_para_enganche" => "Meses Para Enganche",
      "aporte_inicial" => "Aporte Inicial",
      "cuota_enganche" => "Cuota Enganche",
      "lugar_fecha" => "Lugar Fecha",
      "nombre_vendedor" => "Nombre Vendedor",
      "saldo_financiar" => "Saldo Financiar",
      "tasa_anual" => "Tasa Anual",
      "cuota_mantenimiento_activa" => "Cuota Mantenimiento Activa",
      "cuota_mantenimiento_pasiva" => "Cuota Mantenimiento Pasiva"
    }
      .merge(subtype_extra_test_variables)
      .merge(client_test_variables(1))
      .merge(client_test_variables(2))
  end

  def client_test_variables(id)
    label = "aplicante_#{id}"

    {
      "nombres_#{label}" => "Nombres Aplicante #{id}",
      "apellidos_#{label}" => "Apellidos Aplicante #{id}",
      "tipo_id_#{label}" => "Tipo Id Aplicante #{id}",
      "numero_id_#{label}" => "Numero Id Aplicante #{id}",
      "edad_#{label}" => "Edad Aplicante #{id}",
      "estado_civil_#{label}" => "Estado Civil Aplicante #{id}",
      "nacionalidad_#{label}" => "Nacionalidad Aplicante #{id}",
      "profesion_#{label}" => "Profesion Aplicante #{id}",
      "telefono_#{label}" => "Telefono Aplicante #{id}",
      "preferencia_contacto_#{label}" => "Preferencia Contacto Aplicante #{id}",
      "nit_#{label}" => "Nit Aplicante #{id}",
      "correo_#{label}" => "Correo Aplicante #{id}",
      "direccion_#{label}" => "Direccion Aplicante #{id}",
      "ciudad_#{label}" => "Ciudad Aplicante #{id}",
      "departamento_#{label}" => "Departamento Aplicante #{id}",
      "pais_#{label}" => "Pais Aplicante #{id}",
      "empresa_labora_#{label}" => "Empresa Labora Aplicante #{id}",
      "direccion_empresa_#{label}" => "Direccion Empresa Aplicante #{id}",
      "cargo_#{label}" => "Cargo Aplicante #{id}",
      "tiempo_laborar_#{label}" => "Tiempo Laborar Aplicante #{id}",
      "ingresos_#{label}" => "Ingresos Aplicante #{id}",
      "nombre_referencia_1_#{label}" => "Nombre Referencia 1 Aplicante #{id}",
      "parentesco_referencia_1_#{label}" => "Parentesco Referencia 1 Aplicante #{id}",
      "direccion_referencia_1_#{label}" => "Direccion Referencia 1 Aplicante #{id}",
      "telefono_referencia_1_#{label}" => "Telefono Referencia 1 Aplicante #{id}",
      "nombre_referencia_2_#{label}" => "Nombre Referencia 2 Aplicante #{id}",
      "parentesco_referencia_2_#{label}" => "Parentesco Referencia 2 Aplicante #{id}",
      "direccion_referencia_2_#{label}" => "Direccion Referencia 2 Aplicante #{id}",
      "telefono_referencia_2_#{label}" => "Telefono Referencia 2 Aplicante #{id}"
    }
  end

  def subtype_extra_variables
    Array(control_unit_sub_type_subtype_variable_data)
      .first(6)
      .each_with_index.with_object({}) do |(hash, i), out|
        key, val = hash.first
        out["subtipo_extras_#{i + 1}"] = "#{key}: #{val}"
      end
      .tap do |h|
        # Any index out of bounds defaults to ""
        (h.size + 1..6).each { |n| h["subtipo_extras_#{n}"] = "" }
      end
  end

  def subtype_extra_test_variables
    (1..6).each_with_object({}) do |n, h|
      h["subtipo_extras_#{n}"] = "#{n}. Nombre: Variable (extra)"
    end
  end
end
