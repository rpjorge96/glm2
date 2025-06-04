class SaleRequestTemplatesController < ApplicationController
  before_action :set_sale_request_template, only: %i[show edit update destroy preview]
  before_action :set_default_sort_by, only: %i[index]
  before_action :set_query_params, only: %i[index]
  layout "pdf", only: :preview

  def index
    @headers = [
      {name: "Plantilla", field: "name", sortable: true},
      {name: "Proyectos asignados", field: "project_names", sortable: false},
      {name: "Fecha de creación", field: "created_at", sortable: false},
      {name: "Fecha de actualización", field: "updated_at", sortable: false}
    ]

    @q = SaleRequestTemplate.all.ransack(params[:q])
    sale_request_templates = @q.result(distinct: true)

    sale_request_templates = sale_request_templates.includes(:projects)

    @pagy, @sale_request_templates = process_query_params(sale_request_templates)
  end

  def show
  end

  def new
    @sale_request_template = SaleRequestTemplate.new
    @projects = Project.active
  end

  def edit
    @projects = Project.active
  end

  def create
    @sale_request_template = SaleRequestTemplate.new(sale_request_template_params)

    if @sale_request_template.save
      redirect_to sale_request_template_url(@sale_request_template), notice: "La plantilla fue creada exitosamente."
    else
      @projects = Project.all
      flash.now[:alert] = "La plantilla no pudo ser creada."
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @sale_request_template.update(sale_request_template_params)
      redirect_to @sale_request_template, notice: "La plantilla fue actualizada exitosamente."
    else
      @projects = Project.all
      flash.now[:alert] = "La plantilla no pudo ser creada."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @sale_request_template.destroy
    redirect_to sale_request_templates_url, notice: "La plantilla fue eliminada exitosamente."
  end

  def preview
    respond_to do |format|
      format.html
      format.pdf do
        pdf = GenerateSaleRequestTemplatePreviewPdf.new(@sale_request_template).call
        send_data pdf, filename: "#{@sale_request_template.name}.pdf",
          type: "application/pdf",
          disposition: "inline"
      end
    end
  rescue
    redirect_to sale_request_templates_path,
      alert: "Ocurrio un error al generar el PDF. Contacte a soporte indicando el error y el ID. de la plantilla ##{@sale_request_template.id}"
  end

  private

  def set_sale_request_template
    @sale_request_template = SaleRequestTemplate.find(params[:id])
  end

  def set_default_sort_by
    if params[:sort_by].nil?
      params[:sort_by] = "name"
    end
  end

  def sale_request_template_params
    params.require(:sale_request_template).permit(:name, :body, :control_unit_status_id, project_ids: [])
  end
end
