# frozen_string_literal: true

module Projects
  class ControlUnitsController < ApplicationController
    include ControlUnits
    include ApplicationHelper
    before_action :set_project, only: %i[index new create import_create import_update export_template]
    before_action :get_clients_info
    before_action :set_default_sort_by, only: %i[index]
    before_action :set_query_params, only: %i[index]

    # GET /control_units or /control_units.json
    def index
      @headers = [
        {name: "Código", field: "code", sortable: true},
        {name: "Tipo", field: "control_unit_type_name", sortable: true},
        {name: "Subtipo", field: "control_unit_sub_type_name", sortable: true},
        {name: "Estado", field: "control_unit_status_name", sortable: true},
        {name: "Usuario", field: "user", sortable: false},
        {name: "Fecha de creación", field: "created_at", sortable: false},
        {name: "Fecha de actualización", field: "updated_at", sortable: false}
      ]

      @q = @project.control_units.ransack(params[:q])
      control_units = @q.result(distinct: true)

      control_units = control_units.left_joins(:control_unit_status, :control_unit_type, :control_unit_sub_type)
        .select("control_units.*,
       control_unit_types.name AS control_unit_type_name,
       control_unit_sub_types.name AS control_unit_sub_type_name,
       control_unit_statuses.name AS control_unit_status_name")
        .where("control_units.code LIKE :search OR control_unit_types.name LIKE :search OR control_unit_statuses.name LIKE :search", search: "%#{params[:search]}%")

      @pagy, @control_units = process_query_params(control_units)
    end

    # GET /control_units/new
    def new
      @control_unit = @project.control_units.build
      @control_unit.build_control_unit_sale_detail
      @control_unit_status = ControlUnitStatus.for_user(current_user)

      @control_unit_sub_types = []
      @control_unit_types = ControlUnitType.all.collect { |c| [c.name, c.id] }
      @control_unit.identificacion_registral = [{}] if @control_unit.identificacion_registral.blank?
    end

    # POST /control_units or /control_units.json
    def create
      uri = URI.parse(request.referer)
      query_params = URI.decode_www_form(uri.query || "").to_h
      tab_value = query_params["tab"]

      result = convert_dynamic_data(params, 6)
      key_value_pairs = result[0]
      keys = result[1]

      @control_unit_sub_types = []
      @control_unit_types = ControlUnitType.all.collect { |c| [c.name, c.id] }
      @control_unit = @project.control_units.new(control_unit_params)
      @control_unit.user_role = current_user.role_name
      @control_unit_status = ControlUnitStatus.for_user(current_user)

      @type = params[:control_unit][:control_unit_type_id]
      @subtype = params[:control_unit][:control_unit_sub_type_id]
      @type_id = ControlUnitType.find_by(name: @type)&.id
      @subtype_id = ControlUnitSubType.find_by(name: @subtype, control_unit_type_id: @type_id)&.id

      @control_unit.control_unit_type_id = @type_id
      @control_unit.control_unit_sub_type_id = @subtype_id

      @control_unit.control_unit_sale_detail_attributes = control_unit_params[:control_unit_sale_detail_attributes].merge(property_dynamic_fields: key_value_pairs)

      if keys.uniq.length != keys.length
        flash.now[:alert] = "Las variables de subtipo no pueden repetirse."
        render :new, status: :unprocessable_entity
      elsif @control_unit.save
        if @control_unit.control_unit_sale_detail.present?
          @sale_detail = @control_unit.control_unit_sale_detail

          if @sale_detail.applicant_1_id.present?
            ControlUnitApplicant.create(client_id: @sale_detail.applicant_1_id, control_unit_id: @control_unit.id, applicant_type: 0)
          end
          if @sale_detail.applicant_2_id.present?
            ControlUnitApplicant.create(client_id: @sale_detail.applicant_2_id, control_unit_id: @control_unit.id, applicant_type: 1)
          end
        end
        redirect_to control_unit_path(@control_unit, tab: tab_value || "creation-tab"), notice: "La unidad de control fue creada exitosamente."
      else
        flash.now[:alert] = "La unidad de control no pudo ser creada."
        render :new, status: :unprocessable_entity
      end
    end

    def import_create
      if params[:file].nil?
        redirect_to project_path(@project, tab: "import-create"), alert: "No se ha seleccionado un archivo."
        return
      end

      # Proceso de importación que devuelve un hash con los resultados
      import_logs = @project.control_units.import_create(params[:file], current_user.role_name, @project)

      ImportLog.create(importable: @project, import_type: :Creación, log_message: import_logs,
        file_name: params[:file].original_filename)

      redirect_to project_path(@project, tab: "import-create", show_logs: true),
        notice: "Archivo procesado para creación. Revisar logs."
    end

    def import_update
      if params[:file].nil?
        redirect_to project_path(@project, tab: "import-update"), alert: "No se ha seleccionado un archivo."
        return
      end
      # Proceso de importación que devuelve un hash con los resultados
      import_logs = @project.control_units.import_update(params[:file], current_user.role_name, @project)

      ImportLog.create(importable: @project, import_type: :Actualización, log_message: import_logs,
        file_name: params[:file].original_filename)

      redirect_to project_path(@project, tab: "import-update", show_logs: true),
        notice: "Archivo procesado para actualización. Revisar logs."
    end

    def export_template
      mapping = ControlUnit.dynamic_mapping(@project)
      sale_detail_mapping = ControlUnitSaleDetail::MAPPING
      final_mapping = mapping.merge(sale_detail_mapping)

      # Index de columnas dedicadas a DPI:NIT para Aplicante 1 y 2
      dpi_nit_keys = ["applicant_1_dpi", "applicant_1_nit", "applicant_2_dpi", "applicant_2_nit"]
      dpi_nit_column_indexes = dpi_nit_keys.map { |key| final_mapping.values.index(key) }.compact

      # Generacion de archivo Excel
      package = Axlsx::Package.new
      workbook = package.workbook

      workbook.styles do |s|
        number_format = s.add_style(format_code: "0") # Formato numero DPI:NIT
        text_format = s.add_style(format_code: "@") # Formato texto para evitar pérdida de ceros iniciales

        workbook.add_worksheet(name: "Plantilla unidades de control") do |sheet|
          sheet.add_row final_mapping.keys

          # Aplicacion de Formato numero a columnas involucradas
          dpi_nit_column_indexes.each do |col_index|
            sheet.column_info[col_index].width = 30
            sheet.column_info[col_index].style = number_format
          end

          sheet.column_info[1].style = text_format
        end
      end

      # Envio de archivo para descarga
      send_data package.to_stream.read,
        filename: "#{@project.name.parameterize}_plantilla_#{Time.current.strftime("%Y-%m-%d")}.xlsx",
        disposition: "attachment",
        type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    end

    private

    def get_clients_info
      @clients = Client.select(:id, :tipo_de_cliente, :nombres, :apellidos, :dpi, :denominacion_nombre_comercial, :nit, :teléfono_celular, :correo_electrónico).order(id: :asc)
      @clients = @clients.map do |client|
        display_text = if client.tipo_de_cliente == "Jurídico"
          client.nit.present? ? "#{client.denominacion_nombre_comercial} - #{client.nit}" : client.denominacion_nombre_comercial
        else
          client.dpi.present? ? "#{client.nombres} #{client.apellidos} - #{client.dpi}" : "#{client.nombres} #{client.apellidos}"
        end
        client.attributes.merge(display_text: display_text)
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:project_id])
    end

    def set_default_sort_by
      if params[:sort_by].nil?
        params[:sort_by] = "code"
      end
    end

    # Only allow a list of trusted parameters through.
    def control_unit_params
      control_unit_params_with_code_values
    end
  end
end
