# frozen_string_literal: true

class ControlUnitSettingsController < ApplicationController
  def subtypes
    control_unit_type_name = params[:type]
    project_id = params[:project_id]

    # Find the ControlUnitType by name
    control_unit_type = ControlUnitType.find_by(name: control_unit_type_name)
    render_not_found(control_unit_type_name) unless control_unit_type

    subtypes = control_unit_type.control_unit_sub_types
      .for_project(project_id)
      .distinct

    render json: subtypes.any? ? subtypes.pluck(:id, :name) : [[nil, ""]]
  end

  private

  def render_not_found(control_unit_type_name)
    render json: {error: "Tipo de unidad de control no encontrado: #{control_unit_type_name}"},
      status: :not_found
  end
end
