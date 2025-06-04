# frozen_string_literal: true

class ControlUnitSubTypesController < ApplicationController
  include ApplicationHelper
  before_action :set_control_unit_sub_type, only: %i[show edit update destroy versions]
  before_action :set_default_sort_by, only: %i[index]
  before_action :set_query_params, only: %i[index]

  def index
    @headers = [
      {name: "Nombre", field: "control_unit_sub_types.name", sortable: true},
      {name: "Tipo", field: "types_name", sortable: true},
      {name: "Proyecto", field: nil},
      {name: "Fecha de creación", field: "created_at"},
      {name: "Fecha de actualización", field: "updated_at"},
      {name: "Acciones", field: nil}
    ]

    @q = ControlUnitSubType.ransack(params[:q])
    @control_unit_sub_types = @q.result(distinct: true)
      .joins(:control_unit_type)
      .select("control_unit_sub_types.*, LOWER(control_unit_types.name) AS types_name")
    @pagy, @control_unit_sub_types = process_query_params(@control_unit_sub_types)
  end

  def show
  end

  def new
    @projects_ids = []
    @control_unit_sub_type = ControlUnitSubType.new
  end

  def edit
    @projects_ids = @control_unit_sub_type.projects.map(&:id)
    @control_unit_sub_type = ControlUnitSubType.find(params[:id])
  end

  def create
    result = convert_dynamic_data(params, 12)
    extras = convert_subtype_variable_data(params)
    key_value_pairs = result[0]
    keys = result[1]
    @control_unit_sub_type = ControlUnitSubType.new(control_unit_sub_type_params.merge(subtype_data: key_value_pairs).merge(subtype_variable_data: extras))
    if keys.uniq.length != keys.length
      flash.now[:alert] = "Las variables de subtipo no pueden repetirse."
      render :new, status: :unprocessable_entity
    elsif @control_unit_sub_type.save
      save_sub_type_projects(
        @control_unit_sub_type,
        control_unit_sub_type_projects_params[:projects_ids]
      )
      redirect_to @control_unit_sub_type, notice: "El subtipo fue creado exitosamente."
    else
      flash.now[:alert] = "El subtipo no pudo ser creado."
      render :new, status: :unprocessable_entity
    end
  end

  def update
    result = convert_dynamic_data(params, 12)
    extras = convert_subtype_variable_data(params)
    key_value_pairs = result[0]
    keys = result[1]
    if keys.uniq.length != keys.length
      flash.now[:alert] = "Las variables de subtipo no pueden repetirse."
      render :edit, status: :unprocessable_entity
    elsif @control_unit_sub_type.update(
      control_unit_sub_type_params
        .merge(subtype_data: key_value_pairs)
        .merge(subtype_variable_data: extras)
    )
      delete_sub_type_projects(@control_unit_sub_type,
        control_unit_sub_type_projects_params[:projects_ids])
      save_sub_type_projects(@control_unit_sub_type,
        control_unit_sub_type_projects_params[:projects_ids])
      if params[:remove_files].present?
        params[:remove_files].each do |file_key, value|
          @control_unit_sub_type.public_send(file_key).purge if value == "1"
        end
      end
      redirect_to @control_unit_sub_type, notice: "El subtipo se actualizó exitosamente."
    else
      flash.now[:alert] = "El subtipo no pudo ser actualizado."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    respond_to do |format|
      if @control_unit_sub_type.destroy
        format.html { redirect_to control_unit_sub_types_url, notice: "El subtipo  fue eliminado con éxito." }
      end
    rescue ActiveRecord::InvalidForeignKey
      format.html do
        redirect_to control_unit_sub_type_url(@control_unit_sub_type),
          alert: "El subtipo #{@control_unit_sub_type.name} no se puede eliminar porque tiene unidades de control asociadas"
      end
    end
  end

  def versions
  end

  private

  def set_default_sort_by
    if params[:sort_by].nil?
      params[:sort_by] = "control_unit_sub_types.name"
    end
  end

  def convert_subtype_data(params)
    key_value_pairs = []
    keys = []
    (1..12).each do |i|
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

  def convert_subtype_variable_data(params)
    extras = []
    (1..6).each do |i|
      key = params["extra_key#{i}"]
      value = params["extra_value#{i}"]
      next if key.blank? && value.blank?
      extras << {key => value}
    end
    extras
  end

  def save_sub_type_projects(control_unit_sub_type, projects_ids)
    projects_ids.split(",").map(&:to_i).each do |project_id|
      ControlUnitSubTypeProject.find_or_create_by(control_unit_sub_type_id: control_unit_sub_type.id,
        project_id:)
    end
  end

  def delete_sub_type_projects(control_unit_sub_type, projects_ids)
    ControlUnitSubTypeProject.where(control_unit_sub_type_id: control_unit_sub_type.id)
      .where.not(project_id: projects_ids.split(",").map(&:to_i)).destroy_all
  end

  def set_control_unit_sub_type
    @control_unit_sub_type = ControlUnitSubType.find(params[:id])
  end

  def control_unit_sub_type_params
    params.require(:control_unit_sub_type).permit(:name, :control_unit_type_id, :plano_del_subtipo,
      :detalles_constructivos, :description, :lotes_minimos,
      :imagen1, :imagen2, :imagen3, :imagen4, :img2_desc, :img3_desc, :img4_desc,
      :garden_area, :balconies_terrace_area, :parking_spaces, :parking_type,
      :passive_maintenance_fee, :active_maintenance_fee, :passive_maintenance_fee_dollars, :active_maintenance_fee_dollars,
      :key1, :key2, :key3, :key4, :key5, :key6, :key7, :key8, :key9, :key10, :key11, :key12,
      :value1, :value2, :value3, :value4, :value5, :value6, :value7, :value8, :value9, :value10, :value11, :value12)
  end

  def control_unit_sub_type_projects_params
    params.require(:control_unit_sub_type).permit(:projects_ids)
  end
end
