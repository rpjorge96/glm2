module Ventas
  class ReservesController < ApplicationController
    before_action :set_reserve, only: [:show, :edit, :update, :destroy]
    before_action :set_default_sort_by, only: %i[index]
    before_action :set_query_params, only: %i[index]

    def index
      @headers = [
        {name: "No. de reserva", field: "reference_number", sortable: true},
        {name: "Nombre Cliente", field: "client_name", sortable: true},
        {name: "Unidad de control", field: "control_unit_code"},
        {name: "Monto", field: "quantity", sortable: true},
        {name: "Estado", field: "nil"},
        {name: "Vendedor", field: "user_name"},
        {name: "Acciones", field: nil}
      ]
      @q = Reserve.ransack(params[:q])
      @reserves = @q.result(distinct: true)
      @reserves = @reserves.joins(:client).joins(:user)
      @reserves = @reserves.select("reserves.*,
        LOWER(CONCAT(clients.nombres, ' ', clients.apellidos)) AS client_name,
        LOWER(users.name) AS user_name")
      @pagy, @reserves = process_query_params(@reserves)
    end

    def show
    end

    def new
      @reserve = Reserve.new
    end

    def create
      @reserve = Reserve.new(reserve_params)
      @reserve.user = current_user
      if @reserve.save
        redirect_to ventas_reserves_url(@reserve), notice: "La reserva fue creada exitosamente"
      else
        flash.now[:alert] = "La reserva no pudo ser creada"
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @reserve.update(reserve_params)
        redirect_to ventas_reserve_url(@reserve), notice: "La reserva fue actualizada exitosamente"
      else
        flash.now[:alert] = "La reserva no pudo ser actualizada"
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @reserve.destroy
      redirect_to ventas_reserves_url, notice: "La reserva fue eliminada exitosamente"
    end

    private

    def set_default_sort_by
      if params[:sort_by].nil?
        params[:sort_by] = "reference_number"
      end
    end

    def set_reserve
      @reserve = Reserve.find(params[:id])
    end

    def reserve_params
      params.require(:reserve).permit(:quantity, :receipt_number, :quotation_id, :tipo_de_identificacion_cliente_id, :client_id)
    end
  end
end
