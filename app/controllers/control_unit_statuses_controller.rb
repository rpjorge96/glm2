# frozen_string_literal: true

class ControlUnitStatusesController < ApplicationController
  before_action :set_control_unit_status, only: %i[show edit update destroy]

  # GET /roles or /roles.json
  def index
    @control_unit_statuses = ControlUnitStatus.all
  end

  def show
  end

  # GET /roles/new
  def new
    @control_unit_status = ControlUnitStatus.new
  end

  def edit
  end

  def create
    @control_unit_status = ControlUnitStatus.new(role_params)

    respond_to do |format|
      if @control_unit_status.save
        format.html do
          redirect_to control_unit_status_url(@control_unit_status), notice: "El estado fue creado exitosamente."
        end
        format.json { render :show, status: :created, location: @control_unit_status }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @control_unit_status.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @control_unit_status.update(role_params)
        format.html do
          redirect_to control_unit_status_url(@control_unit_status), notice: "El estado se actualizó exitosamente."
        end
        format.json { render :show, status: :ok, location: @control_unit_status }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @control_unit_status.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @control_unit_status.destroy
    respond_to do |format|
      format.html { redirect_to control_unit_statuses_url, notice: "El estado  fue eliminado con éxito." }
      format.json { render :show, status: :ok, location: @control_unit_status }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_control_unit_status
    @control_unit_status = ControlUnitStatus.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def role_params
    params.require(:control_unit_status).permit(:name, :color)
  end
end
