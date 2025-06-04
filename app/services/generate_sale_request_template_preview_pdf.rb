class GenerateSaleRequestTemplatePreviewPdf
  include Rails.application.routes.url_helpers

  def initialize(sale_request_template)
    @sale_request_template = sale_request_template
  end

  def call
    html_content = ApplicationController.render(
      template: "sale_request_templates/preview",
      layout: "pdf",
      assigns: {sale_request_template: @sale_request_template}
    )
    grover = Grover.new(html_content,
      format: "letter",
      margin: {
        top: "0px",
        bottom: "0px",
        left: "0px",
        right: "0px"
      },
      wait_until: ["networkidle0", "load", "domcontentloaded", "networkidle2"],
      print_background: true,
      request_timeout: 1000000,
      focus: "#loaded")

    grover.to_pdf
  rescue => e
    raise GenerateSaleRequestTemplatePreviewPdfError.new(@sale_request_template, e.message)
  end
end

class GenerateSaleRequestTemplatePreviewPdfError < StandardError
  attr_reader :sale_request_template

  def initialize(sale_request_template, message)
    @sale_request_template = sale_request_template
    super("Error generando PDF: Plantilla de Solicitud de Venta - #{sale_request_template.id} - #{message}")
  end
end
