# frozen_string_literal: true

module Configurations
  class TipoDeIdentificacionClientesController < ApplicationController
    before_action :set_tipo_de_identificacion_cliente, only: %i[show edit update destroy]

    def index
      @tipo_de_identificacion_clientes = TipoDeIdentificacionCliente.all
    end

    def show
    end

    def new
      @tipo_de_identificacion_cliente = TipoDeIdentificacionCliente.new
    end

    def edit
    end

    def create
      @tipo_de_identificacion_cliente = TipoDeIdentificacionCliente.new(tipo_de_identificacion_cliente_params)

      respond_to do |format|
        if @tipo_de_identificacion_cliente.save
          format.html do
            redirect_to configurations_tipo_de_identificacion_cliente_url(@tipo_de_identificacion_cliente),
              notice: "El tipo fue creado exitosamente."
          end
        else
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @tipo_de_identificacion_cliente.update(tipo_de_identificacion_cliente_params)
          format.html do
            redirect_to configurations_tipo_de_identificacion_cliente_url(@tipo_de_identificacion_cliente),
              notice: "El tipo se actualizó exitosamente."
          end
        else
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      respond_to do |format|
        if @tipo_de_identificacion_cliente.destroy
          format.html do
            redirect_to configurations_tipo_de_identificacion_clientes_url, notice: "El tipo  fue eliminado con éxito."
          end
        else
          format.html do
            redirect_to configurations_tipo_de_identificacion_clientes_url,
              alert: "El tipo #{@tipo_de_identificacion_cliente.nombre} no se puede eliminar"
          end
        end
      end
    end

    private

    def set_tipo_de_identificacion_cliente
      @tipo_de_identificacion_cliente = TipoDeIdentificacionCliente.find(params[:id])
    end

    def tipo_de_identificacion_cliente_params
      params.require(:tipo_de_identificacion_cliente).permit(:nombre)
    end
  end
end
