# frozen_string_literal: true

class FinancialEntitiesController < ApplicationController
  before_action :set_financial_entity, only: %i[show edit update destroy]

  def index
    @financial_entities = FinancialEntity.all
  end

  def show
  end

  def new
    @financial_entity = FinancialEntity.new
  end

  def edit
    @financial_entity = FinancialEntity.find(params[:id])
  end

  def create
    @financial_entity = FinancialEntity.new(financial_entity_params)
    if @financial_entity.save
      redirect_to financial_entity_url(@financial_entity), notice: "La entidad financiera fue creada exitosamente."
    else
      flash.now[:alert] = "La entidad financiera no pudo ser creado."
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @financial_entity.update(financial_entity_params)
      redirect_to financial_entity_url(@financial_entity), notice: "La entidad financiera se actualizó exitosamente."
    else
      flash.now[:alert] = "La entidad financiera no pudo ser actualizada."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    respond_to do |format|
      if @financial_entity.destroy
        format.html { redirect_to financial_entities_url, notice: "La entidad financiera fue eliminada con éxito." }
      else
        format.html do
          redirect_to financial_entities_url,
            alert: "La entidad financiera #{@financial_entity.name} no se puede eliminar porque tiene cotizaciones asociadas."
        end
      end
    end
  end

  private

  def set_financial_entity
    @financial_entity = FinancialEntity.find(params[:id])
  end

  def financial_entity_params
    params.require(:financial_entity).permit(:name, :down_payment_percentage, :annual_interest_rate,
      :minimum_down_payment, :minimum_down_payment_dollar,
      :maximum_years_to_finance, :discount_percentage,
      :financing_type, :months_to_pay_down_payment, :porcentaje_pago_inicial, :note1, :note2)
  end
end
