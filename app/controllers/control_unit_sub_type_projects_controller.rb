# frozen_string_literal: true

class ControlUnitSubTypeProjectsController < ApplicationController
  before_action :set_control_unit_sub_type_project, only: %i[show update]

  def show
  end

  def update
    respond_to do |format|
      if @control_unit_sub_type_project.update(control_unit_sub_type_project_params)
        format.html do
          redirect_to control_unit_sub_type_url(@control_unit_sub_type_project.control_unit_sub_type),
            notice: "El subtipo: #{@control_unit_sub_type_project.control_unit_sub_type.name} del proyecto: #{@control_unit_sub_type_project.project.name} actualizó exitosamente."
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_control_unit_sub_type_project
    @control_unit_sub_type_project = ControlUnitSubTypeProject.find(params[:id])
  end

  def control_unit_sub_type_project_params
    params.require(:control_unit_sub_type_project).permit(:precio, :precio_dollar)
  end
end
