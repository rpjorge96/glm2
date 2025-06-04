# frozen_string_literal: true

module Ventas
  class ListadoDePrecioArchivosController < ApplicationController
    before_action :set_listado_de_precio_archivo, only: %i[show edit update destroy]

    def index
      @listado_de_precio_archivos = ListadoDePrecioArchivo.all
    end

    def new
      @listado_de_precio_archivo = ListadoDePrecioArchivo.new
    end

    def create
      @listado_de_precio_archivo = ListadoDePrecioArchivo.new(listado_de_precio_archivo_params)
      if @listado_de_precio_archivo.save
        ListadoDePrecioArchivos::Import.call(@listado_de_precio_archivo)
        redirect_to ventas_listado_de_precio_archivo_url(@listado_de_precio_archivo),
          notice: "El listado de precio fue creado exitosamente."
      else
        render :new
      end
    end

    def show
    end

    def edit
    end

    def update
      if @listado_de_precio_archivo.update(listado_de_precio_archivo_params)
        redirect_to ventas_listado_de_precio_archivo_url(@listado_de_precio_archivo),
          notice: "El listado de precio fue actualizado exitosamente."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @listado_de_precio_archivo.destroy
      redirect_to ventas_listado_de_precio_archivos_path, notice: "El listado de precio fue eliminado exitosamente."
    end

    private

    def set_listado_de_precio_archivo
      @listado_de_precio_archivo = ListadoDePrecioArchivo.find(params[:id])
    end

    def listado_de_precio_archivo_params
      params.require(:listado_de_precio_archivo).permit(:nombre, :fecha_de_listado, :archivo)
    end
  end
end
