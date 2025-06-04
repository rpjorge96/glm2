# frozen_string_literal: true

class ControlUnitTypesController < ApplicationController
  before_action :set_control_unit_type, only: %i[show edit update destroy versions]

  def index
    @control_unit_types = ControlUnitType.all
  end

  def show
  end

  def new
    @control_unit_type = ControlUnitType.new
  end

  def edit
  end

  def create
    @control_unit_type = ControlUnitType.new(control_unit_type_params)

    respond_to do |format|
      if @control_unit_type.save
        format.html do
          redirect_to control_unit_type_url(@control_unit_type), notice: "El tipo fue creado exitosamente."
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @control_unit_type.update(control_unit_type_params)
        format.html do
          redirect_to control_unit_type_url(@control_unit_type), notice: "El tipo se actualizó exitosamente."
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @control_unit_type.destroy
        format.html { redirect_to control_unit_types_url, notice: "El tipo  fue eliminado con éxito." }
      else
        # flash[:alert] = 'No se puede eliminar el rol porque tiene usuarios asociados'
        format.html do
          redirect_to control_unit_types_url,
            alert: "El tipo #{@control_unit_type.name} no se puede eliminar porque tiene subtipos asociados"
        end
      end
    end
  end

  def versions
  end

  private

  def set_control_unit_type
    @control_unit_type = ControlUnitType.find(params[:id])
  end

  def control_unit_type_params
    params.require(:control_unit_type).permit(:name)
  end
end
