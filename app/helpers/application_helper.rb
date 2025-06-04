# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend
  # def label_with_required_indicator(object, field, label_text, options = {})
  #   if object.class.validators_on(field).any? { |v| v.is_a?(ActiveRecord::Validations::PresenceValidator) }
  #     label_text += ' <span class="required-asterisk">*</span>'.html_safe
  #   end

  #   label(object, field, label_text.html_safe, options)
  # end

  def form_label(form, attribute)
    is_required = form.object.class.validators_on(attribute).any?(ActiveRecord::Validations::PresenceValidator)

    form.label attribute, class: div_label_form_class do
      label = form.object.class.human_attribute_name(attribute)
      label += ' <span class="required-asterisk" style="color: red;">*</span>'.html_safe if is_required
      label.html_safe
    end
  end

  def form_class
    "bg-white dark:bg-gray-900 py-8 px-4 mx-auto lg:py-2"
  end

  def div_error_class
    "text-red-600"
  end

  def div_field_form_class
    "mb-4"
  end

  def div_label_form_class
    "block mb-2 text-sm font-medium text-gray-900 dark:text-white"
  end

  # def first_field_class
  #   'bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-primary-600 focus:border-primary-600 block w-full p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500'
  # end

  def field_class
    "block p-2.5 w-full text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500"
  end

  def short_field_class
    field_class.gsub("w-full", "w-50")
  end

  def hidden_field_class
    "w-full mb-5 bg-gray-100 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block p-2.5 cursor-not-allowed dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
  end

  def short_hidden_field_class
    hidden_field_class.gsub("w-full", "w-50")
  end

  def submit_class
    "inline-flex items-center px-5 py-2.5 mb-4 sm:mb-6 text-sm font-medium text-center text-white bg-primary-700 rounded-lg focus:ring-4 focus:ring-primary-200 dark:focus:ring-primary-900 hover:bg-primary-800"
  end

  def datepicker_field(form, field)
    placeholder_text = "Selecciona una fecha"
    content_tag(:div, class: "relative") do
      icon = content_tag(:div, class: "absolute inset-y-0 start-0 flex items-center ps-3.5 pointer-events-none") do
        # Aquí va tu SVG o icono
        content_tag(:svg, class: "w-4 h-4 text-gray-500 dark:text-gray-400", "aria-hidden": "true",
          xmlns: "http://www.w3.org/2000/svg", fill: "currentColor", viewBox: "0 0 20 20") do
          content_tag(:path, nil,
            d: "M20 4a2 2 0 0 0-2-2h-2V1a1 1 0 0 0-2 0v1h-3V1a1 1 0 0 0-2 0v1H6V1a1 1 0 0 0-2 0v1H2a2 2 0 0 0-2 2v2h20V4ZM0 18a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V8H0v10Zm5-8h10a1 1 0 0 1 0 2H5a1 1 0 0 1 0-2Z")
        end
      end
      formatted_date = form.object.send(field)&.strftime("%d/%m/%Y")
      input = form.text_field field, value: formatted_date, datepicker: true, "datepicker-format": "dd/mm/yyyy", placeholder: placeholder_text,
        class: "bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full ps-10 p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"

      icon + input
    end
  end

  def currency_of(value, currency)
    unit = if currency == "GTQ"
      "Q "
    elsif currency == "USD"
      "$ "
    else
      ""
    end
    number_to_currency(value, precision: 2, delimiter: ",", unit: unit, format: "%u%n")
  end

  def convert_dynamic_data(params, max_fields)
    key_value_pairs = []
    keys = []
    (1..max_fields).each do |i|
      key = params["key#{i}"]
      value = params["value#{i}"]

      if key.present? && value.present?
        keys << key
        key_value_pairs << {}
        key_value_pairs.last[key] = value
      end
    end
    [key_value_pairs, keys]
  end

  def text_color(bg_hex)
    hex = bg_hex.to_s.delete("#")
    return "#000000" unless hex.match?(/\A\h{6}\z/)

    r = hex[0..1].to_i(16)
    g = hex[2..3].to_i(16)
    b = hex[4..5].to_i(16)

    luminance = (r * 299 + g * 587 + b * 114) / 1000
    (luminance > 128) ? "#000000" : "#FFFFFF"
  end
end
