# frozen_string_literal: true

module Ventas
  class ControlUnitsController < ApplicationController
    before_action :set_available_houses, only: %i[index]
    before_action :set_default_sort_by, only: %i[index]
    before_action :set_query_params, only: %i[index]

    def index
      @headers = [
        {name: "", field: nil},
        {name: "Código", field: "code", sortable: true},
        {name: "Unidad", field: nil},
        {name: "Subtipo", field: "sub_type_name", sortable: true},
        {name: "Precio de lista", field: "precio_de_lista_cents", sortable: true},
        {name: "Estado", field: nil}
      ]

      # Si el usuario posee el rol Vendedor, pre-selecciona los proyectos relacionados al usuario que esten activos para cotizar.
      if current_user.vendedor?
        @skip_project_modal = true
        assigned_ids = current_user.projects.active.pluck(:id)
        @q = ControlUnit.libres.where(project_id: assigned_ids).ransack(params[:q])
        @selected_project_id = nil
      else
        @skip_project_modal = false
        @selected_project_id = params[:project_id]
        @q = ControlUnit.libres.ransack(params[:q])
      end

      # Materializar ransack + filtro opcional de proyecto único (para no vendedores)
      @control_units = @q.result(distinct: true)
      if !@skip_project_modal && @selected_project_id.present?
        @control_units = @control_units.where(project_id: @selected_project_id)
      end

      @control_units = @control_units
        .joins(:sub_type)
        .select("control_units.*", "control_unit_sub_types.name AS sub_type_name")

      @pagy, @control_units = process_query_params(@control_units)

      @projects = Project.active

      @opened = !@skip_project_modal && @selected_project_id.nil?
    end

    # def show; end

    # def new
    #   @control_unit = ControlUnit.new
    # end

    # def edit; end

    # def create
    #   @control_unit = ControlUnit.new(control_unit_params)

    #   if @control_unit.save
    #     redirect_to ventas_control_units_path, notice: 'Control unit was successfully created.'
    #   else
    #     render :new
    #   end
    # end

    # def update
    #   if @control_unit.update(control_unit_params)
    #     redirect_to ventas_control_units_path, notice: 'Control unit was successfully updated.'
    #   else
    #     render :edit
    #   end
    # end

    # def destroy
    #   @control_unit.destroy
    #   redirect_to ventas_control_units_url, notice: 'Control unit was successfully destroyed.'
    # end

    # private

    # def set_control_unit
    #   @control_unit = ControlUnit.find(params[:id])
    # end

    # def control_unit_params
    #   params.require(:control_unit).permit(:code, :user_id, :precio_de_lista)
    # end

    private

    def set_available_houses
      @available_houses = Project.all.each_with_object({}) do |project, hash|
        hash[project.code] = project.control_unit_sub_type_projects.each_with_object([]) do |control_unit_sub_type_project, sub_types|
          next unless control_unit_sub_type_project.control_unit_sub_type.lotes_minimos

          control_unit_sub_type = control_unit_sub_type_project.control_unit_sub_type

          sub_types << {
            id: control_unit_sub_type.id,
            control_unit_sub_type_project_id: control_unit_sub_type_project.id,
            name: control_unit_sub_type.name,
            minimum_lots: control_unit_sub_type.lotes_minimos,
            price: control_unit_sub_type_project.precio.to_f,
            price_dollar: control_unit_sub_type_project.precio_dollar.to_f
          }
        end
      end
    end

    def set_default_sort_by
      if params[:sort_by].nil?
        params[:sort_by] = "code"
      end
    end
  end
end
