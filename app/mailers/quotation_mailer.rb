# frozen_string_literal: true

class QuotationMailer < ApplicationMailer
  include SendGrid

  def send_quotation_email(quotation, logging: false)
    project = quotation.project
    control_unit_type = quotation.control_unit_type

    quotation.generate_pdf
    pdf = quotation.pdf
    pdf_path = download_pdf_from_active_storage(pdf)

    unless pdf_path && File.exist?(pdf_path) && !File.zero?(pdf_path)
      raise "Downloaded PDF is missing, empty, or corrupted: #{pdf_path}"
    end

    mail = Mail.new
    mail.from = Email.new(email: "noresponder@sg.glm.com.gt")

    personalization = Personalization.new
    begin
      personalization.add_to(Email.new(email: quotation.client_email))
    rescue
      raise "El email es inválido."
    end
    personalization.add_dynamic_template_data({
      "subject" => "#{project.name} - #{control_unit_type.name} (#{quotation.reference_number})",
      "client_name" => quotation.client_name
    })
    mail.add_personalization(personalization)
    mail.template_id = "d-fca8dd8e821a494f87a1d764184e7788"

    File.open(pdf_path, "rb") do |file|
      attachment = Attachment.new
      attachment.content = Base64.strict_encode64(file.read) # Fix: Strict encoding
      attachment.type = "application/pdf"
      attachment.filename = "quotation_#{quotation.reference_number}.pdf"
      attachment.disposition = "attachment"
      mail.add_attachment(attachment)
    end

    sg = SendGrid::API.new(api_key: ENV["SENDGRID_API_KEY"])

    response = sg.client.mail._("send").post(request_body: mail.to_json)

    if logging
      puts "SendGrid Response Code: #{response.status_code}"
      puts "SendGrid Response Body: #{response.body}"
    end
  ensure
    FileUtils.rm_f(pdf_path) if pdf_path
  end

  private

  def download_pdf_from_active_storage(pdf_attachment)
    return nil unless pdf_attachment.attached?

    temp_path = Rails.root.join("tmp", "document_#{SecureRandom.hex}.pdf")

    File.binwrite(temp_path, pdf_attachment.download)

    temp_path
  end
end
