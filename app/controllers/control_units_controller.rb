# frozen_string_literal: true

class ControlUnitsController < ApplicationController
  include ApplicationHelper
  include ControlUnits
  before_action :get_clients_info
  before_action :set_active_tab, only: [:show, :edit]
  before_action :set_control_unit, only: %i[show edit update destroy versions]

  # GET /control_units/1 or /control_units/1.json
  def show
    @boundaries = @control_unit.boundaries
    @sale_detail = @control_unit.control_unit_sale_detail
    @payment_detail = @control_unit.control_unit_payment_detail
    set_clients_username(@payment_detail)

    @applicant_1, @applicant_1_display_text = get_applicant(1)
    @applicant_2, @applicant_2_display_text = get_applicant(2)
  end

  # GET /control_units/1/edit
  def edit
    @is_admin = current_user.admin?
    @control_unit.build_control_unit_payment_detail if @control_unit.control_unit_payment_detail.nil?
    @control_unit.build_control_unit_sale_detail if @control_unit.control_unit_sale_detail.nil?

    @control_unit_status = ControlUnitStatus.for_user(current_user)
    @control_unit_sub_types = if @control_unit.control_unit_type_id.present?
      # Carga los subtipos basados en el tipo seleccionado
      @control_unit.project.control_unit_sub_types.where(control_unit_type_id: @control_unit.type.id).all.collect do |c|
        [c.id, c.name]
      end
    else
      # Opcional: Carga un conjunto predeterminado de subtipos o déjalo vacío
      ControlUnitSubType.none # o ControlUnitSubType.none para vacío
    end

    # Asegúrate de tener disponible @control_unit_types para el select de ControlUnitType
    @control_unit_types = ControlUnitType.all.collect { |c| [c.name, c.id] }

    @control_unit.identificacion_registral = [{}] if @control_unit.identificacion_registral.blank?

    @control_unit_type_name = @control_unit.type&.name
    @control_unit_sub_type_name = @control_unit.sub_type&.name

    @sale_detail = @control_unit.control_unit_sale_detail
    @payment_detail = @control_unit.control_unit_payment_detail
    set_clients_username(@payment_detail)

    # for sale detail
    @sale_detail.applicant_1_display_text = get_applicant(1)[1]
    @sale_detail.applicant_2_display_text = get_applicant(2)[1]

    # for payment detail
    @applicant_1, @applicant_1_display_text = get_applicant(1)
  end

  # PATCH/PUT /control_units/1 or /control_units/1.json
  def update
    uri = URI.parse(request.referer)
    query_params = URI.decode_www_form(uri.query || "").to_h
    tab_value = query_params["tab"]

    result = convert_dynamic_data(params, 6)
    key_value_pairs = result[0]
    keys = result[1]

    @control_unit.is_admin = current_user.admin?
    @control_unit.user_role = current_user.role_name
    @payment_detail = @control_unit.control_unit_payment_detail

    @type = params[:control_unit][:control_unit_type_id]
    @subtype = params[:control_unit][:control_unit_sub_type_id]
    @type_id = ControlUnitType.find_by(name: @type)&.id
    @subtype_id = ControlUnitSubType.find_by(name: @subtype, control_unit_type_id: @type_id)&.id

    @control_unit_types = ControlUnitType.all.collect { |c| [c.name, c.id] }
    @control_unit_sub_types = if @type_id.present?
      # Carga los subtipos basados en el tipo seleccionado
      @control_unit.project.control_unit_sub_types.where(control_unit_type_id: @type_id).all.collect do |c|
        [c.id, c.name]
      end
    else
      # Opcional: Carga un conjunto predeterminado de subtipos o déjalo vacío
      ControlUnitSubType.none # o ControlUnitSubType.none para vacío
    end

    @control_unit.control_unit_payment_detail_attributes = control_unit_params[:control_unit_payment_detail_attributes] if control_unit_params[:control_unit_payment_detail_attributes]
    @control_unit.control_unit_sale_detail_attributes = control_unit_params[:control_unit_sale_detail_attributes].merge(property_dynamic_fields: key_value_pairs)
    control_unit_params_full = add_payment_details_params(@payment_detail, control_unit_params)

    if keys.uniq.length != keys.length
      @control_unit_status = ControlUnitStatus.for_user(current_user)
      flash.now[:alert] = "Las variables dinámicas no pueden repetirse."
      render :edit, status: :unprocessable_entity
    elsif @control_unit.update(control_unit_params_full.merge(control_unit_type_id: @type_id, control_unit_sub_type_id: @subtype_id))
      if @control_unit.control_unit_sale_detail.present?
        @sale_detail = @control_unit.control_unit_sale_detail
        create_update_applicants
      end
      redirect_to control_unit_url(tab: tab_value || "creation-tab"), notice: "La unidad de control se actualizó exitosamente."
    else
      @tab = tab_value || "creation-tab"
      @control_unit_type_name = @type
      @control_unit_sub_type_name = @subtype

      @control_unit_status = ControlUnitStatus.for_user(current_user)

      flash.now[:alert] = "La unidad de control no pudo ser actualizada."
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /control_units/1 or /control_units/1.json
  def destroy
    @control_unit.destroy

    respond_to do |format|
      format.html do
        redirect_to project_path(@control_unit.project), notice: "La unidad de control fue eliminada con éxito."
      end
      format.json { head :no_content }
    end
  end

  def versions
    @control_units = @control_unit.versions
  end

  def export_form
  end

  def export
    @fields = params[:fields] || ControlUnit::MAPPING.values
    @control_units = if params[:project_id].present?
      Project.find(params[:project_id]).control_units
    else
      ControlUnit.all
    end
    project_name = if params[:project_id].present?
      Project.find(params[:project_id]).name
    else
      "Todos"
    end

    respond_to do |format|
      format.xlsx do
        response.headers["Content-Disposition"] = 'attachment; filename="unidades_de_control.xlsx"'
      end

      # format.pdf do
      #   render pdf: 'unidades_de_control',
      #          formats: [:html],
      #          orientation: 'Landscape',
      #          layout: 'pdf',
      #          disposition: 'inline'
      #   #  filename: "unidades_de_control.pdf"
      # end

      format.pdf do
        send_data ControlUnitReportGenerator.generate(@control_units, @fields, project_name),
          filename: "reporte_proyectos.pdf",
          type: "application/pdf",
          disposition: "inline"
      end
    end
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

  def get_applicant(n = 1)
    applicant = case n
    when 1
      Client.find_by(id: @sale_detail&.applicant_1_id)
    when 2
      Client.find_by(id: @sale_detail&.applicant_2_id)
    end

    applicant_display_text = if applicant
      client_display_text(applicant)
    else
      "N/A"
    end

    [applicant, applicant_display_text]
  end

  def set_active_tab
    @active_tab = params[:tab] || @tab || "creation-tab"
  end

  def create_update_applicants
    applicant_1 = ControlUnitApplicant.find_by(control_unit_id: @control_unit.id, applicant_type: 0)
    if @sale_detail.applicant_1_id.present?
      if applicant_1
        applicant_1.update(client_id: @sale_detail.applicant_1_id)
      else
        ControlUnitApplicant.create(client_id: @sale_detail.applicant_1_id, control_unit_id: @control_unit.id, applicant_type: 0)
      end
    elsif applicant_1
      applicant_1.destroy
    end

    applicant_2 = ControlUnitApplicant.find_by(control_unit_id: @control_unit.id, applicant_type: 1)
    if @sale_detail.applicant_2_id.present?
      if applicant_2
        applicant_2.update(client_id: @sale_detail.applicant_2_id)
      else
        ControlUnitApplicant.create(client_id: @sale_detail.applicant_2_id, control_unit_id: @control_unit.id, applicant_type: 1)
      end
    elsif applicant_2
      applicant_2.destroy
    end
  end

  def client_display_text(client)
    if client.tipo_de_cliente == "Jurídico"
      client.nit.present? ? "#{client.denominacion_nombre_comercial} - #{client.nit}" : client.denominacion_nombre_comercial
    else
      client.dpi.present? ? "#{client.nombres} #{client.apellidos} - #{client.dpi}" : "#{client.nombres} #{client.apellidos}"
    end
  end

  def set_clients_username(payments)
    return nil if payments.nil?

    list = %w[extra_payments down_payments monthly_payments late_payments capital_payments total_payments]
    list.map do |payment|
      payments[payment]&.map do |hash|
        hash["username"] = User.find(hash["user_id"]).username if hash["user_id"]
      end
    end
  end

  def add_payment_details_params(payment_detail, control_unit_params)
    control_unit_params_full = control_unit_params.to_unsafe_h
    list = %w[extra_payments down_payments monthly_payments late_payments capital_payments total_payments]
    list.map do |payment|
      control_unit_params_full[:control_unit_payment_detail_attributes][payment]&.each_with_index do |hash, index|
        default_user_id = nil
        default_updated_at = nil
        was_modified = true

        if !payment_detail.nil? && index < payment_detail[payment].length
          hash&.delete("user_id")
          hash&.delete("updated_at")
          default_user_id = payment_detail[payment][index]&.delete("user_id")
          default_updated_at = payment_detail[payment][index]&.delete("updated_at")
          was_modified = hash != payment_detail[payment][index]
        end

        hash["user_id"] = was_modified ? current_user.id : default_user_id
        hash["updated_at"] = was_modified ? Time.now.in_time_zone("America/Guatemala") : default_updated_at
      end
    end
    control_unit_params_full
  end

  def set_control_unit
    @control_unit = ControlUnit.kept.find(params[:id])
    @project = @control_unit.project
  end

  def control_unit_params
    control_unit_params_with_code_values
  end
end
