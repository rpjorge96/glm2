# frozen_string_literal: true

module Ventas
  class ListadoDePreciosController < ApplicationController
    # before_action :set_listado_de_precio, only: %i[show edit update destroy]

    def index
      search_params = params.permit(:page, :format,
        q: [:control_unit_code_cont])
      @q = ListadoDePrecio.ransack(params[:q])
      @query = search_params[:q]

      @pagy, @listado_de_precios = pagy_countless(@q.result.includes(:control_unit))
      # @listado_de_precios = ListadoDePrecio.all
    end

    # private
    # def set_listado_de_precio
    #   @listado_de_precio = ListadoDePrecio.find(params[:id])
    # end
  end
end
