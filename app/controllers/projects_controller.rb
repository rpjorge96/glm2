# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :prepare_create_project, only: %i[create]
  before_action :set_project, only: %i[show edit update destroy]
  before_action :set_countries_list, only: %i[new edit create update]
  before_action :prepare_control_unit_code_settings, only: %i[create update]

  # GET /projects or /projects.json
  def index
    search_params = params.permit(:id, :page, :format,
      q: [:name_or_code_or_país_or_departamento_estado_or_municipio_ciudad_cont])
    @q = Project.ransack(params[:q])
    @query = search_params[:q]
    @pagy, @projects = pagy_countless(@q.result(distinct: true))
  end

  # GET /projects/1 or /projects/1.json
  def show
    @fincas = @project.fincas
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects or /projects.json
  def create
    if @project.save
      redirect_to project_url(@project), notice: "El proyecto fue creado exitosamente."
    else
      flash.now[:alert] = "El proyecto no pudo ser creado."
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /projects/1 or /projects/1.json
  def update
    [:project_logo, :pdf_header, :pdf_footer, :icon1, :icon2, :icon3, :icon4, :plano_del_proyecto].each do |field|
      if params[:remove_files]&.[](field.to_s) == "1"
        @project.public_send(field).purge_later if @project.public_send(field).attached?
      end
    end
    if @project.update(project_params)
      redirect_to project_url(@project), notice: "El proyecto se actualizó exitosamente."
    else
      flash.now[:alert] = "El proyecto no pudo ser actualizado."
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /projects/1 or /projects/1.json
  def destroy
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_url, notice: "El proyecto fue eliminado con éxito." }
      format.json { head :no_content }
    end
  end

  def export_form
  end

  def export
    @projects = Project.all
    respond_to do |format|
      format.html # index.html.erb
      format.pdf do
        send_data ProjectReportGenerator.generate(@projects),
          filename: "reporte_proyectos.pdf",
          type: "application/pdf",
          disposition: "inline"
      end
    end
  end

  private

  def prepare_create_project
    @project = Project.new(project_params)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def project_params
    permitted_params = params.require(:project).permit(
      :name, :description, :país, :departamento_estado, :includes_deed_expenses, :is_active,
      :municipio_ciudad, :code, :internal_code, :days_to_book, :operation_initial_date, :plano_del_proyecto,
      :project_logo, :phone, :website_url, :pdf_header, :pdf_footer, :quotation_valid_days, :propietary, :service_company,
      :icon1, :icon2, :icon3, :icon4, :icon1_url, :icon2_url, :icon3_url, :icon4_url,
      :title_color, :price_color, :final_price_color, :bg_field_color,
      remove_files: [:project_logo, :pdf_header, :pdf_footer, :icon1, :icon2, :icon3, :icon4]
    )

    social_media_links = {
      icon1: permitted_params.delete(:icon1_url),
      icon2: permitted_params.delete(:icon2_url),
      icon3: permitted_params.delete(:icon3_url),
      icon4: permitted_params.delete(:icon4_url)
    }.compact.to_json

    permitted_params.merge(social_media_links:)
  end

  def set_countries_list
    set_countries_list_from_settings
    set_subdivisions_list
    set_cities_list
  end

  def set_countries_list_from_settings
    codes = CountrySetting.first.códigos
    @countries_list = Country.all.select { |country| codes.include?(country.alpha2) }
      .map { |country| country.translations["es"] }
  end

  def set_subdivisions_list
    @subdivisions_list = if @project&.país&.present?
      @project.country_class.subdivision_names
    else
      []
    end
  end

  def set_cities_list
    return @cities_list = [] unless @project&.departamento_estado

    cs_cities = CS.cities(@project.subdivision_code, @project.country_code) || []
    db_cities = City.where(country_code: @project&.country_code,
      state_code: @project&.subdivision_code).pluck(:name) || []
    @cities_list = (cs_cities + db_cities).uniq
  end

  def prepare_control_unit_code_settings
    enabled_settings = params[:control_unit_code_settings].to_a.reject(&:empty?)
    custom_name1 = params[:project][:control_unit_code_settings_custom1]
    custom_name2 = params[:project][:control_unit_code_settings_custom2]
    custom_name3 = params[:project][:control_unit_code_settings_custom3]

    error = true if enabled_settings.include?("custom1") && custom_name1.blank?
    error = true if enabled_settings.include?("custom2") && custom_name2.blank?
    error = true if enabled_settings.include?("custom3") && custom_name3.blank?

    # redirect_to edit or new action with error message
    return redirect_to(request.referer, alert: "Debe ingresar un nombre para los campos personalizados.") if error

    settings = {
      "numero_inicial" => enabled_settings.include?("numero_inicial"),
      "sufijos" => enabled_settings.include?("sufijos"),
      "re_compra" => enabled_settings.include?("re_compra"),
      "re_venta" => enabled_settings.include?("re_venta")
    }

    settings[custom_name1] = enabled_settings.include?("custom1")
    settings[custom_name2] = enabled_settings.include?("custom2")
    settings[custom_name3] = enabled_settings.include?("custom3")

    @project.control_unit_code_settings = settings.to_json
  end
end
