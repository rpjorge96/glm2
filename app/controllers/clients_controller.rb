# frozen_string_literal: true

class ClientsController < ApplicationController
  before_action :set_client, only: %i[show edit update destroy]
  before_action :set_default_sort_by, only: %i[index]
  before_action :set_query_params, only: %i[index]

  def index
    @headers = [
      {name: "Nombre completo", field: "complete_name", sortable: true},
      {name: "Tipo identificación", field: "tipo_de_identificacion_cliente_id", sortable: true},
      {name: "Número identificación", field: "identification_number", sortable: true},
      {name: "Teléfono celular", field: "phone_number", sortable: true},
      {name: "Solicitante", field: nil, sortable: false},
      {name: "Unidad de control", field: nil, sortable: false},
      {name: "Fecha de Creación", field: "created_at", sortable: true},
      {name: "Fecha de Actualización", field: "updated_at", sortable: true}
    ]

    @q = Client.all.ransack(params[:q])
    @clients = @q.result(distinct: true).includes(control_unit_applicants: :control_unit)

    @clients = @clients.includes(:tipo_de_identificacion_cliente).select("clients.*,
                        CASE
                          WHEN tipo_de_cliente = 0 AND clients.nombres IS NOT NULL THEN CONCAT(clients.nombres, ' ', clients.apellidos)
                          WHEN tipo_de_cliente = 1 THEN clients.denominacion_nombre_comercial
                          ELSE NULL
                        END AS complete_name,
                        CASE
                          WHEN tipo_de_cliente = 0 THEN COALESCE(clients.dpi, 'No encontrado')
                          WHEN tipo_de_cliente = 1 THEN COALESCE(clients.nit, 'No encontrado')
                          ELSE NULL
                        END AS identification_number,
                        clients.teléfono_celular AS phone_number")

    @pagy, @clients = process_query_params(@clients)
  end

  def show
    @applicant_from = @client.control_unit_applicants
  end

  def new
    @client = Client.new
  end

  def edit
  end

  def create
    @client = Client.new(client_params)
    if @client.save
      redirect_to client_url(@client), notice: "El cliente fue creado exitosamente."
    else
      flash.now[:alert] = "El cliente no pudo ser creado."
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @client.update(client_params)
      redirect_to client_url(@client), notice: "El cliente se actualizó exitosamente."
    else
      flash.now[:alert] = "El cliente no pudo ser actualizado."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @client.destroy

    respond_to do |format|
      format.html { redirect_to clients_url, notice: "El cliente fue eliminado con éxito." }
      format.json { head :no_content }
    end
  end

  private

  def set_default_sort_by
    if params[:sort_by].nil?
      params[:sort_by] = "complete_name"
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_client
    @client = Client.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def client_params
    params.require(:client).permit(:cargo_o_puesto, :ciudad, :correo_electrónico, :departamento_o_estado, :dirección,
      :dirección_de_referencia1, :dirección_de_referencia2, :dpi, :estado_civil, :address, :contact_preference,
      :fecha_de_nacimiento, :género, :ingresos_mensuales_promedio, :nacionalidad, :nit,
      :nombres, :nombre_de_referencia1, :nombre_de_referencia2, :nombre_empresa_donde_labora,
      :número_de_personas_que_integran_grupo_familiar, :parentesco_de_referencia1,
      :parentesco_de_referencia2, :país, :profesión_u_oficio, :teléfono_celular,
      :teléfono_de_referencia1, :teléfono_de_referencia2, :tiempo_de_laborar, :created_at,
      :updated_at, :apellidos, :tipo_de_identificacion_cliente_id, :tipo_de_cliente,
      :denominacion_nombre_comercial, :tipo_de_entidad, :no_expediente_y_año, :registro,
      :folio, :libro, :numero_de_escritura, :lugar_de_escritura, :fecha_de_escritura,
      :notario_autorizante, :objeto_actividad_economica, :domicilio_de_representante_legal,
      :nit_de_representante_legal, :cargo, :numero_de_nombramiento, :folio_de_nombramiento,
      :libro_de_nombramiento, :fecha_vigencia_del_nombramiento, :años_de_vigencia_del_nombramiento)
  end
end
