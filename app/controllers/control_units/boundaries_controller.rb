# frozen_string_literal: true

module ControlUnits
  class BoundariesController < ApplicationController
    before_action :set_control_unit, only: %i[index new create update]

    # GET /boundaries or /boundaries.json
    def index
      @boundaries = @control_unit.boundaries
    end

    # GET /boundaries/new
    def new
      count = params[:count].to_i
      if count.zero? && @control_unit.boundaries.empty?
        redirect_back fallback_location: root_path, alert: "Se requieren al menos 1 para crear un lado del polígono"
      else
        build_boundaries(count)
      end
    end

    def update
      @control_unit_types = ControlUnitType.all.collect { |c| [c.name, c.id] }
      @control_unit_sub_types = []
      @control_unit.is_admin = current_user.admin?
      @control_unit.user_role = current_user.role_name
      respond_to do |format|
        if @control_unit.update(control_unit_params)
          if control_unit_params[:boundaries_attributes].to_h.size < @control_unit.boundaries.count
            to_destroy = Boundary.unscoped.where(control_unit_id: @control_unit.id).order(station: :desc).limit(@control_unit.boundaries.count - control_unit_params[:boundaries_attributes].to_h.size)
            to_destroy.destroy_all
            @control_unit.reload
          end
          format.html do
            redirect_to control_unit_url, notice: "La unidad de control se actualizó exitosamente."
          end
          format.json { render :show, status: :ok, location: @control_unit }
        else
          @control_unit_status = ControlUnitStatus.for_user(current_user)
          @control_unit.reload
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @control_unit.errors, status: :unprocessable_entity }
        end
      end
    end

    # POST /boundaries or /boundaries.json
    def create
    end

    # PATCH/PUT /boundaries/1 or /boundaries/1.json

    private

    def build_boundaries(count)
      if @control_unit.boundaries.empty?
        new_or_add_build_boundaries(count)
      else
        update_build_boundaries(count)
      end
    end

    def new_or_add_build_boundaries(count_or_add)
      original_count = @control_unit.boundaries.count || 0
      counter = original_count
      count = count_or_add - original_count
      count.times do |index|
        point = if index == count - 1
          0
        else
          counter + 1
        end
        @control_unit.boundaries.build(station: counter,
          observed_point: point)
        counter += 1
      end
      @control_unit.boundaries[original_count - 1].observed_point = original_count
    end

    def remove_build_boundaries(count)
      @remove_count = count
    end

    def update_build_boundaries(count)
      original_count = @control_unit.boundaries.count
      if count > original_count
        new_or_add_build_boundaries(count)
      elsif count == original_count
        nil
      else
        remove_build_boundaries(count)
      end
    end

    def set_control_unit
      id = params[:control_unit_id] || params[:id]
      @control_unit = ControlUnit.find(id)
    end

    # Only allow a list of trusted parameters through.
    def boundary_params
      params.require(:boundary).permit(:station, :observed_point, :azimuth, :distance, :neighbor, :control_units_id)
    end

    def control_unit_params
      params.require(:control_unit).permit(
        boundaries_attributes: %i[id station observed_point azimuth distance
          neighbor control_unit_id _destroy]
      )
    end
  end
end
