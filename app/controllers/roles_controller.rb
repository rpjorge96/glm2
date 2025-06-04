# frozen_string_literal: true

class RolesController < ApplicationController
  before_action :set_role, only: %i[show edit update destroy]
  before_action :set_default_sort_by, only: %i[index]
  before_action :set_query_params, only: %i[index]

  # GET /roles or /roles.json
  def index
    @headers = [
      {name: "Nombre", field: "name_case_insensitive", sortable: true},
      {name: "Fecha de creación", field: "created_at"},
      {name: "Fecha de actualización", field: "updated_at"},
      {name: "Acciones", field: nil}
    ]

    @q = Role.ransack(params[:q])
    @roles = @q.result(distinct: true)
    @roles = @roles.select("roles.*, LOWER(name) AS name_case_insensitive")
    @pagy, @roles = process_query_params(@roles)
  end

  # GET /roles/1 or /roles/1.json
  def show
  end

  # GET /roles/new
  def new
    @role = Role.new
  end

  # GET /roles/1/edit
  def edit
  end

  # POST /roles or /roles.json
  def create
    @role = Role.new(role_params)
    if @role.save
      redirect_to role_url(@role), notice: "El rol fue creado exitosamente."
    else
      flash.now[:alert] = "El rol no pudo ser creado."
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /roles/1 or /roles/1.json
  def update
    if @role.update(role_params)
      redirect_to role_url(@role), notice: "El rol se actualizó exitosamente."
    else
      flash.now[:alert] = "El rol no pudo ser actualizado."
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /roles/1 or /roles/1.json
  def destroy
    respond_to do |format|
      if @role.destroy
        format.html { redirect_to roles_url, notice: "El rol  fue eliminado con éxito." }
        format.json { render :show, status: :ok, location: @role }
      else
        # flash[:alert] = 'No se puede eliminar el rol porque tiene usuarios asociados'
        format.html do
          redirect_to roles_url, alert: "El rol #{@role.name} no se puede eliminar porque tiene usuarios asociados"
        end
      end
    end
  end

  private

  def set_default_sort_by
    if params[:sort_by].nil?
      params[:sort_by] = "name_case_insensitive"
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_role
    @role = Role.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def role_params
    params.require(:role).permit(:name, :max_allowed_discount_percentage, :max_days_extend_reservation, :max_days_extend_quotation)
  end
end
