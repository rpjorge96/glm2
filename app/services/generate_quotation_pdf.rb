class GenerateQuotationPdf
  include Rails.application.routes.url_helpers

  def initialize(quotation)
    @quotation = quotation
  end

  def call
    html_content = ApplicationController.render(
      template: "ventas/control_units/quotations/pdf",
      layout: "pdf",
      assigns: {quotation: @quotation}
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

    pdf = grover.to_pdf
    attach_pdf(pdf)
    pdf
  end

  def attach_pdf(pdf)
    @quotation.pdf.attach(io: StringIO.new(pdf), filename: "cotizacion.pdf", content_type: "application/pdf")
  end
end
