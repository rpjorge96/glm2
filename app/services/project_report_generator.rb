# frozen_string_literal: true

require "prawn"
require "prawn/table"

class ProjectReportGenerator
  def self.generate(projects)
    Prawn::Document.new(page_layout: :landscape, page_size: "LEGAL") do |pdf|
      pdf.text "Reporte de Proyectos", size: 20, style: :bold

      table_data = [["#", "Código", "Nombre", "Descripción", "País", "Departamento - Estado", "Municipio - Ciudad",
        "Inicio de operaciones", "Fecha de creación", "Fecha de actualización"]]

      projects.each_with_index do |project, index|
        # Usamos el correlativo en lugar del ID y luego lo incrementamos
        created_at_string = project.created_at.strftime("%d/%m/%Y %H:%M")
        updated_at_string = project.updated_at.strftime("%d/%m/%Y %H:%M")
        if project.operation_initial_date.present?
          opeeration_initial_date = project.operation_initial_date.strftime("%d/%m/%Y")
        end

        table_data << [index + 1, project.code, project.name.to_s, project.description.to_s, project.país.to_s,
          project.departamento_estado.to_s, project.municipio_ciudad.to_s, opeeration_initial_date,
          created_at_string, updated_at_string]
      end

      pdf.table(table_data, header: true)
    end.render
  end
end
