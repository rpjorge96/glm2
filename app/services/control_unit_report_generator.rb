# frozen_string_literal: true

require "prawn"
require "prawn/table"

class ControlUnitReportGenerator
  def self.generate(control_units, fields, proyecto)
    project = control_units.first&.project
    dynamic_mapping = ControlUnit.dynamic_mapping(project)

    Prawn::Document.new(page_size: [4_000, 1008], page_layout: :portrait) do |pdf|
      pdf.text "Reporte de Unidades de Control. Proyecto: #{proyecto}", size: 20, style: :bold

      # Headers a partir de keys de dynamic_mapping
      headers = fields.map do |field|
        dynamic_mapping.key(field) || I18n.t("activerecord.attributes.control_unit.#{field}", default: field.titleize)
      end
      headers.unshift("#")

      # Preparacion de datos para cada row
      data = control_units.each_with_index.map do |control_unit, index|
        fields.map do |field|
          mapped_label = dynamic_mapping.key(field)

          value = if field == "project_id"
            control_unit.project&.name
          elsif field == "control_unit_status_id"
            control_unit.control_unit_status&.name
          elsif field == "control_unit_type_id"
            ControlUnitType.find_by(id: control_unit.control_unit_type_id)&.name
          elsif field == "control_unit_sub_type_id"
            ControlUnitSubType.find_by(id: control_unit.control_unit_sub_type_id)&.name
          elsif mapped_label && control_unit.code_values.key?(mapped_label) # dinamicos de code_values
            control_unit.code_values[mapped_label] || "N/A"
          elsif %w[numero_inicial suffix_standard suffix_custom].include?(field) # sufijos de code_values
            control_unit.code_values[field] || "N/A"
          else
            begin
              control_unit.send(field)
            rescue
              "N/A"
            end # atributos vacios manejados como N/A
          end

          value.to_s
        end.unshift(index + 1)
      end

      # Insert de table en el PDF
      pdf.table([headers] + data) do |table|
        table.row(0).font_style = :bold
        table.row(0).background_color = "F0F0F0"
      end
    end.render
  end
end
