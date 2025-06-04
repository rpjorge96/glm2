# frozen_string_literal: true

module ControlUnitSubTypes
  class ControlUnitSubTypeProjectsController < ApplicationController
    before_action :set_control_unit_sub_type, only: %i[index]

    def index
      # TODO: Implementar la paginación
      @control_unit_sub_type_projects = @control_unit_sub_type.control_unit_sub_type_projects
    end

    private

    def set_control_unit_sub_type
      @control_unit_sub_type = ControlUnitSubType.find(params[:control_unit_sub_type_id])
    end
  end
end
