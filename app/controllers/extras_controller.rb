# frozen_string_literal: true

class ExtrasController < ApplicationController
  include ExtraHelper

  before_action :set_extra, only: %i[edit update destroy show]

  def index
    # Para manejar extras generales
    @extras = Extra.generales

    search_params = params.permit(:page, :format, q: [:name_cont])

    order_by = search_params[:order].presence || "asc"
    @q = @extras.ransack(params[:q])
    @q.sorts = "name #{order_by}"
    @query = search_params[:q]
    @order = order_by
    @pagy, @extras = pagy_countless(@q.result(distinct: true))
  end

  def show
    # Para manejar extras generales, Note: no needed because we are no using this
    # @projects = @extra.projects
    # @control_unit_types = @extra.control_unit_types
  end

  def new
    # Para manejar extras generales
    @extra = Extra.new
    @projects = Project.all.select(:id, :name)
    @control_unit_types = ControlUnitType.all.select(:id, :name)
    @projects_control_unit_types = []
  end

  def create
    # Para manejar extras generales
    @extra = Extra.new(extra_params)
    if @extra.save
      create_projects_and_control_unit_types
      redirect_to extras_url, notice: "El extra general fue creada exitosamente."
    else
      build_projects_control_unit_types
      flash.now[:alert] = "Extra no pudo ser creado."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    return unless @extra.extrable.blank?

    @projects = Project.all.select(:id, :name)
    @control_unit_types = ControlUnitType.all.select(:id, :name)
    @projects_control_unit_types = @extra.control_unit_types_projects.map do |cup|
      {
        project_id: cup.project_id,
        control_unit_type_id: cup.control_unit_type_id
      }
    end
  end

  def update
    if @extra.update(extra_params)
      create_projects_and_control_unit_types
      if params[:remove_files].present?
        params[:remove_files].each do |file_key, value|
          @extra.public_send(file_key).purge if value == "1"
        end
      end
      redirect_to extrable_url(@extra), notice: "El extra se actualizó exitosamente."
    else
      build_projects_control_unit_types
      flash.now[:alert] = "Extra no pudo ser actualizado."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @extra.control_unit_types_projects.destroy_all
    respond_to do |format|
      if @extra.destroy
        format.html { redirect_to extrable_url(@extra), notice: "El extra se eliminó exitosamente." }
      else
        format.html do
          redirect_to extrable_url(@extra),
            notice: "El extra se no se pudo eliminar. error: #{@extra.errors.full_messages.join(", ")} "
        end
      end
    end
  end

  private

  def set_extra
    @extra = Extra.find(params[:id])
  end

  def extra_params
    params.require(:extra).permit(:name, :precio, :precio_dollar, :adjunto, :description, :unidades_de_medida)
  end

  def projects_and_control_unit_types_params
    params.require(:extra).permit(project_control_unit_type_ids: {})
  end

  def create_projects_and_control_unit_types
    return unless projects_and_control_unit_types_params[:project_control_unit_type_ids].present?

    @extra.control_unit_types_projects.destroy_all

    projects_and_control_unit_types_params[:project_control_unit_type_ids].each do |project_id, types_ids|
      types_ids.each do |type_id|
        cutp = ControlUnitTypesProject.find_or_create_by(project_id:, control_unit_type_id: type_id)
        ControlUnitTypesProjectsExtra.create!(control_unit_types_project_id: cutp.id, extra_id: @extra.id)
      end
    end
  end

  def build_projects_control_unit_types
    @projects = Project.all.select(:id, :name)
    @control_unit_types = ControlUnitType.all.select(:id, :name)

    @projects_control_unit_types = if projects_and_control_unit_types_params[:project_control_unit_type_ids].present?
      projects_and_control_unit_types_params[:project_control_unit_type_ids]&.to_hash&.flat_map do |project_id, control_unit_type_ids|
        control_unit_type_ids.map do |control_unit_type_id|
          {project_id: project_id.to_i, control_unit_type_id: control_unit_type_id.to_i}
        end
      end
    else
      []
    end
  end
end
