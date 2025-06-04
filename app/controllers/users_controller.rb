# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy versions]
  before_action :set_default_sort_by, only: %i[index]
  before_action :set_query_params, only: %i[index]

  # GET /users or /users.json
  def index
    @headers = [
      {name: "Rol", field: "role_names", sortable: true},
      {name: "Nombre de usuario", field: "username_case_insensitive", sortable: true},
      {name: "Nombre", field: "name_case_insensitive", sortable: true},
      {name: "Teléfono", field: "created_at"},
      {name: "Fecha de creación", field: "created_at"},
      {name: "Fecha de actualización", field: "updated_at"},
      {name: "Acciones", field: nil}
    ]

    @q = User.joins(:role).ransack(params[:q])
    @users = @q.result(distinct: true)
    @users = @users
      .select("users.*,
              LOWER(users.username) AS username_case_insensitive,
              LOWER(users.name) AS name_case_insensitive,
              LOWER(roles.name) AS role_names
    ")
    @pagy, @users = process_query_params(@users)
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_url(@user), notice: "El usuario fue creado exitosamente."
    else
      flash.now[:alert] = "El usuario no ha podido ser creado"
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    params = user_params
    params = params.except(:password) if params[:password].blank?
    if @user.update(params)
      redirect_to user_url(@user), notice: "El usuario se actualizó exitosamente."
    else
      flash.now[:alert] = "El usuario no pudo ser actualizado"
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_url, notice: "El usuario  fue eliminado con éxito." }
      format.json { head :no_content }
    end
  end

  def versions
    @users = @user.versions
  end

  private

  def set_default_sort_by
    if params[:sort_by].nil?
      params[:sort_by] = "username_case_insensitive"
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:role_id, :username, :password, :phone, :name, project_ids: [])
  end
end
