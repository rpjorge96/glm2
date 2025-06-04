# frozen_string_literal: true

class BoundariesController < ApplicationController
  before_action :set_boundary, only: %i[show edit update destroy]

  # GET /boundaries/1 or /boundaries/1.json
  def show
  end

  # GET /boundaries/1/edit
  def edit
  end

  def update
    respond_to do |format|
      if @boundary.update(boundary_params)
        format.html { redirect_to boundary_url(@boundary), notice: "El lado del polígono fue actualizado." }
        format.json { render :show, status: :ok, location: @boundary }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @boundary.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /boundaries/1 or /boundaries/1.json
  def destroy
    @boundary.destroy!

    respond_to do |format|
      format.html do
        redirect_to control_unit_path(@boundary.control_unit), notice: "El lado del polígono fue eliminado"
      end
      format.json { head :no_content }
    end
  end

  private

  def set_boundary
    @boundary = Boundary.find(params[:id])
  end

  def boundary_params
    params.require(:boundary).permit(:station, :observed_point, :azimuth, :distance, :neighbor)
  end
end
