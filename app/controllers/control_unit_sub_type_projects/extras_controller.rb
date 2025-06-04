# frozen_string_literal: true

module ControlUnitSubTypeProjects
  class ExtrasController < ApplicationController
    before_action :set_control_unit_sub_type_project, only: %i[index new create]

    def index
      # TODO: Implementar la paginación
      @extras = @control_unit_sub_type_project.extras
    end

    def new
      @extra = @control_unit_sub_type_project.extras.build
    end

    def create
      @extra = @control_unit_sub_type_project.extras.new(extra_params)

      respond_to do |format|
        if @extra.save
          format.html do
            redirect_to control_unit_sub_type_project_path(@control_unit_sub_type_project),
              notice: "El extra para el subtipo fue creada exitosamente."
          end
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end

    private

    def set_control_unit_sub_type_project
      @control_unit_sub_type_project = ControlUnitSubTypeProject.find(params[:control_unit_sub_type_project_id])
    end

    def extra_params
      params.require(:extra).permit(:name, :precio, :precio_dollar, :description, :adjunto, :unidades_de_medida)
    end
  end
end
