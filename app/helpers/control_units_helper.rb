# frozen_string_literal: true

module ControlUnitsHelper
  def format_decimal(area)
    return nil if area.blank?

    format("%.2f", area)
  end

  def format_decimal_fincas(area)
    return nil if area.blank?

    format("%.4f", area)
  end

  def text_field_class_cu_code
    "p-2.5 text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500 w-20"
  end

  def text_field_class_cu_suffix
    "p-2.5 text-sm text-gray-900 bg-gray-50 rounded-lg border border-gray-300 focus:ring-primary-500 focus:border-primary-500 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-primary-500 dark:focus:border-primary-500 w-10"
  end

  def div_control_unit_edit_class
    "py-8 px-4 mx-auto max-w-3xl lg:py-2"
  end

  def form_control_unit_class
    "bg-white dark:bg-gray-900 py-8 px-4 mx-auto lg:py-2"
  end

  def custom_text_field_cu(form, field, options = {})
    form.text_field field, options
  end

  def custom_select_cu(form, field, collection, options = {}, html_options = {})
    form.select field, collection, options, html_options
  end

  def datepicker_field_cu(form, field, options = {})
    disabled = false
    options[:class] =
      "#{options[:class]} #{if disabled
                              "cursor-not-allowed"
                            end} bg-gray-50 border border-gray-300 text-gray-900 text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full pl-10 p-2.5 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
    options[:disabled] = disabled

    # Configuración específica del datepicker
    datepicker_options = {
      datepicker: true,
      "datepicker-format": "dd/mm/yyyy",
      placeholder: "Selecciona una fecha"
    }

    # Combinar opciones específicas del datepicker con las opciones proporcionadas
    combined_options = options.merge(datepicker_options)

    # Formatear la fecha si el objeto tiene un valor para ese campo
    formatted_date = form.object.send(field)&.strftime("%d/%m/%Y")
    combined_options[:value] = formatted_date if formatted_date

    # Crear el campo de texto con las opciones combinadas
    content_tag(:div, class: "relative max-w-sm") do
      icon = content_tag(:div, class: "absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none") do
        # Icono de calendario (puedes ajustar esto según tus necesidades)
        tag.svg(class: "w-5 h-5 text-gray-500", xmlns: "http://www.w3.org/2000/svg", fill: "none", viewBox: "0 0 24 24",
          stroke: "currentColor") do
          tag.path(stroke_linecap: "round", stroke_linejoin: "round", stroke_width: "2",
            d: "M20 4a2 2 0 0 0-2-2h-2V1a1 1 0 0 0-2 0v1h-3V1a1 1 0 0 0-2 0v1H6V1a1 1 0 0 0-2 0v1H2a2 2 0 0 0-2 2v2h20V4ZM0 18a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2V8H0v10Zm5-8h10a1 1 0 0 1 0 2H5a1 1 0 0 1 0-2Z").to_s.html_safe
        end
      end

      # Combina el icono y el input
      icon + form.text_field(field, combined_options)
    end
  end

  def custom_control_data_attribute(group)
    unless current_user.role.name == "Admin" || current_user.role.permissions.where(subject_class: "CustomControlUnitGroup")
        .pluck(:action).include?(group)
      "data-controller=control-units--custom-group"
    end
  end
end
