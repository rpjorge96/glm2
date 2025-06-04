module QuotationPdfHelper
  include ActionView::Helpers::NumberHelper
  include ApplicationHelper

  delegate :all_available_extras, to: :control_unit_object, prefix: true, allow_nil: true
  delegate :passive_maintenance_fee, to: :control_unit_sub_type, prefix: true, allow_nil: true
  delegate :passive_maintenance_fee_dollars, to: :control_unit_sub_type, prefix: true, allow_nil: true
  delegate :passive_maintenance_fee_currency, to: :control_unit_sub_type, prefix: true, allow_nil: true
  delegate :active_maintenance_fee, to: :control_unit_sub_type, prefix: true, allow_nil: true
  delegate :active_maintenance_fee_dollars, to: :control_unit_sub_type, prefix: true, allow_nil: true
  delegate :active_maintenance_fee_currency, to: :control_unit_sub_type, prefix: true, allow_nil: true
  delegate :name, to: :created_by, prefix: true, allow_nil: true
  delegate :phone, to: :created_by, prefix: true, allow_nil: true
  delegate :financial_entities, to: :parsed_params, allow_nil: true
  delegate :subtype_data, to: :control_unit_sub_type, allow_nil: true
  delegate :code_values, to: :control_unit_object, prefix: true, allow_nil: true
  delegate :code, to: :control_unit_object, prefix: true, allow_nil: true

  def control_unit_sub_type
    if custom_house?
      control_unit_sub_type_project&.control_unit_sub_type
    else
      control_unit_object&.sub_type
    end
  end

  def control_unit_type
    control_unit_sub_type&.control_unit_type
  end

  def control_unit_object_code
    if custom_house? && lots.size > 1
      lots.first["code"] + "-" + lots.last["code"].split("-").last
    else
      control_unit["code"]
    end
  end

  def custom_house_lots_code
    return lots.first["code"].split("-").last if lots.size == 1

    lots.first["code"].split("-").last + "-" + lots.last["code"].split("-").last
  end

  def financial_entities_ids
    financial_entities&.map { |fe| fe["id"] }
  end

  def extras
    if custom_house?
      control_unit["extras"].values.first
    else
      control_unit["extras"]
    end
  end

  def selected_extras
    extras.select { |extra| extra["apply"] }
  end

  def currency
    parsed_params["currency"]
  end

  def general_information_table_data
    total_area = number_with_precision(total_construction_area, precision: 2)

    table_rows = (subtype_data&.map { |hash| {values: [hash.keys.first, hash.values.first]} } || []).first(11)

    {
      table_body: [{values: ["Área m²", total_area]}] + table_rows
    }
  end

  def quotation_table_data(final_price_color = "#f6c28a")
    extras_total = format_as_currency(calculated_values["extrasTotal"])
    final_total = format_as_currency(calculated_values["finalTotal"])
    discount_amount = format_as_currency(calculated_values["discountAmount"])
    price_after_discount = format_as_currency(calculated_values["priceAfterDiscount"])

    table_body = [
      {values: ["Total extras", extras_total]},
      {values: ["Sub total", final_total], style: "font-weight: bold;"},
      {values: ["Descuento", discount_amount]},
      {values: ["Precio final", price_after_discount], style: "background-color: #{final_price_color}; font-weight: bold;"}
    ]

    if custom_house?
      lots_price = format_as_currency(lots_total_price)
      house_price = format_as_currency(control_unit_sub_type_price)
      table_body.unshift({values: ["Precio casa", house_price]})
      table_body.unshift({values: ["Precio lotes", lots_price]})
    else
      price = format_as_currency(calculated_values["controlUnitPrice"])
      table_body.unshift({values: ["Precio", price]})
    end

    {table_body: table_body}
  end

  def quotation_cash_table_data(financial_entity_id)
    data = financial_entity_calculated_values(financial_entity_id)
    return {} if data.nil?

    table_data = {
      table_body: [
        {values: ["Pago Inicial", format_as_currency(data["initialCustomPayment"])]}
      ]
    }

    if custom_payments(financial_entity_id).present?
      table_data[:table_body].push({values: ["Pagos personalizados", "Ver tabla"]})
    else
      table_data[:table_body].push({values: ["#{data["monthsToPayDownPayment"]} cuotas de", format_as_currency(data["monthlyPayment"])]})
    end

    table_data
  end

  def quotation_down_payment_table_data(financial_entity_id)
    data = financial_entity_calculated_values(financial_entity_id)
    return {} if data.nil?

    table_data = {
      table_body: [
        {values: ["Enganche", format_as_currency(data["downPayment"])]},
        {values: ["Pago inicial", format_as_currency(data["initialCustomPayment"])]}
      ]
    }

    if custom_payments(financial_entity_id).present?
      table_data[:table_body].push({values: ["Pagos personalizados", "Ver tabla"]})
    else
      table_data[:table_body].push({values: ["#{data["finalMonthsToCession"]} cuotas de", format_as_currency(data["monthlyDownPayment"])]})
    end

    table_data
  end

  def quotation_financing_table_data(financial_entity_id)
    data = financial_entity_calculated_values(financial_entity_id)
    return {} if data.nil?

    years_to_finance = data["yearsToFinance"]

    table_data = {
      table_body: []
    }

    years_to_finance.each do |(key, value)|
      table_data[:table_body] << {values: ["#{key} años", format_as_currency(value)]}
    end

    table_data
  end

  def active_maintenance_fee
    fee = (currency == "GTQ") ? control_unit_sub_type_active_maintenance_fee : control_unit_sub_type_active_maintenance_fee_dollars
    format_as_currency(fee)
  end

  def passive_maintenance_fee
    fee = (currency == "GTQ") ? control_unit_sub_type_passive_maintenance_fee : control_unit_sub_type_passive_maintenance_fee_dollars
    format_as_currency(fee)
  end

  def page_3_info_table_data
    value = format_as_currency(calculated_values["priceAfterDiscount"])

    {
      table_body: [
        {values: ["Cliente", client_name || ""], class: "bold-title"},
        {values: ["Condominio", project.name || ""], class: "bold-title"},
        {values: ["# Apartamento", control_unit_object_número_final || ""], class: "bold-title"},
        {values: ["Fecha", created_at.strftime("%d-%m-%Y")], class: "bold-title"},
        {values: ["Asesor de ventas", last_edited_by_name], class: "bold-title"},
        {values: ["Valor apartamento", value], class: "bold-title"}
        # {values: ["% Enganche", ""], class: "bold-title"}, fix for financing type
        # {values: ["Enganche total", "Q"], class: "bold-title"}
      ]
    }
  end

  def monthly_payment_table_data(financial_entity_id)
    table_headers = ["Meses", "Fecha", "Cantidad"]

    data = {table_body: []}
    footer_config = {}
    custom_payments = custom_payments(financial_entity_id)

    initial_payment_date = Date.new(created_at.year, created_at.month, 1) + 1.month
    initial_payment_date = payment_date(initial_payment_date)
    financial_entity_values = financial_entity_calculated_values(financial_entity_id)
    to_finance = financial_entity_values["toFinance"]
    footer_config[:is_financed] = !(to_finance.nil? || to_finance == 0)
    initial_amount_value = financial_entity_values["initialCustomPayment"]
    formatted_initial_amount = format_as_currency(initial_amount_value)

    if initial_amount_value.to_f != 0
      data[:table_body] << {values: ["0", initial_payment_date.strftime("%d-%m-%Y"), formatted_initial_amount]}
      payment_start_date = initial_payment_date.next_month
    else
      payment_start_date = initial_payment_date
      initial_amount_value == 0
    end

    if custom_payments.present?
      total_sum = populate_table_body(data, custom_payments, payment_start_date, initial_amount_value.to_f)

    else
      values = calculated_values[financial_entity_id.to_s]
      months = values["monthsToPayDownPayment"] || values["finalMonthsToCession"]
      monthly_payment = values["monthlyPayment"] || values["monthlyDownPayment"]

      total_sum = populate_table_body(data, Array.new(months.to_i) { monthly_payment }, payment_start_date, initial_amount_value.to_f)

    end

    footer_config[:total_sum_row] = []
    footer_config[:total_sum_row] = ["", "Total", format_as_currency(total_sum)]
    footer_config[:financed_foot_row] = [] if footer_config[:is_financed]
    if footer_config[:is_financed]
      footer_config[:financed_foot_row] = ["", "Saldo a Financiar", format_as_currency(to_finance)]
    end

    new_data = [{
      table_headers: table_headers,
      table_body: data[:table_body][0..24]
    }]

    if data[:table_body].length > 25
      new_data << {
        table_headers: table_headers,
        table_body: data[:table_body][25..55]
      }
    end

    new_data.each_with_index do |table_data, index|
      if index == new_data.length - 1
        table_data[:table_footer] = footer_config
      end
    end

    new_data
  end

  def extras_data
    selected_extras.sort_by { |extra| extra["apply"] ? 0 : 1 }.each_with_object([]) do |extra, data|
      data << extra_data(extra)
    end

    ## Esto agrega los extras que no fueron seleccionados
    # missing_extras_ids.each do |extra_id|
    #   extra = Extra.find(extra_id)
    #   quotation_extras << {
    #     name: extra.name,
    #     price: 0,
    #     image_url: extra&.adjunto&.url,
    #     description: extra.description,
    #     quantity: "0 (No incluido)",
    #     border_color: "#074b4b"
    #   }
    # end
  end

  def calculate_total_pages(financial_entity_id)
    total_pages = 2
    total_pages += monthly_payment_table_data(financial_entity_id).size
    total_pages + if selected_extras.size.to_f <= 4
      1
    else
      1 + ((selected_extras.size.to_f - 4).to_f / 5).ceil
    end
  end

  def code_data
    data = {}

    project.custom_control_unit_code_settings.each_with_index do |(k, v), index|
      value = control_unit_object_code_values[k]
      value += control_unit_object_code_values["suffix_custom"] if value && index == 2 && project.control_unit_code_settings_suffix_enabled? && control_unit_object_code_values["suffix_custom"].present?
      next unless v && value.present?

      data[k.humanize] = value
    end

    if custom_house?
      data.delete(data.keys.last)
      data["Lote/s"] = custom_house_lots_code
      data["Casa"] = control_unit_sub_type.name
    end

    data
  end

  def total_construction_area
    if custom_house?
      lot_codes = lots.map { |lot| lot["code"] }
      total_area = ControlUnit.where(code: lot_codes).pluck(:area)&.compact&.sum
    else
      total_area = control_unit_object["area"].to_f
    end

    total_area
  end

  def calculated_values
    parsed_params["calculated_values"]
  end

  def format_as_currency(value)
    currency_of(value, currency)
  end

  def payment_day
    payment_day = parsed_params["payment_day"]
    return 1 if payment_day.nil?

    payment_day.to_i
  end

  private

  def custom_payments(financial_entity_id = nil)
    parsed_params.dig("control_units", 0, "custom_payments", financial_entity_id.to_s)
  end

  def missing_extras_ids
    control_unit_object_all_available_extras.map { |extra| extra["id"] } - extras.map { |extra| extra["id"] }
  end

  def extra_data(extra)
    extra_object = Extra.find_by(id: extra["id"])
    price = (currency == "GTQ") ? extra["price"] : extra["price_dollar"]
    quantity = extra["quantity"] || 0
    total = price * quantity
    {
      name: extra["name"],
      price: format_as_currency(price),
      image_url: extra_object&.adjunto&.url,
      description: extra_object&.description || "N/A",
      border_color: "#074b4b",
      quantity:,
      total: format_as_currency(total)
    }
  end

  def financial_entity_calculated_values(financial_entity_id)
    calculated_values[financial_entity_id.to_s]
  end

  def populate_table_body(data, payments, payment_start_date, initial_sum)
    total_sum = initial_sum
    payments.each_with_index.each_with_object(data) do |(payment, index), table_data|
      payment_date = payment_start_date + index.months
      amount = payment.is_a?(Array) ? payment.last : payment
      total_sum += amount.to_f
      table_data[:table_body] << {values: [(index + 1).to_s, payment_date.strftime("%d-%m-%Y"), format_as_currency(amount)]}
    end
    total_sum
  end

  def lots_total_price
    lots.map do |lot|
      control_unit = ControlUnit.find_by(code: lot["code"])
      (currency == "GTQ") ? control_unit&.precio_de_lista.to_f : control_unit&.precio_de_lista_dollar.to_f
    end.sum
  end

  def control_unit_sub_type_price
    (currency == "GTQ") ? control_unit_sub_type_project.precio.to_f : control_unit_sub_type_project.precio_dollar.to_f
  end

  def control_unit_sub_type_project
    ControlUnitSubTypeProject.find(control_unit["subtype_project_hash"].values.first)
  end

  def payment_date(date)
    last_day = Date.new(date.year, date.month, -1).day
    actual_day = (payment_day > last_day) ? last_day : payment_day
    Date.new(date.year, date.month, actual_day)
  end
end
