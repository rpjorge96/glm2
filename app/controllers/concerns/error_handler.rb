# app/controllers/concerns/error_handling.rb
module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
    rescue_from StandardError, with: :handle_standard_error
  end

  private

  def handle_record_not_found(exception)
    log_error(exception)
    redirect_to root_path, alert: "El recurso que buscas no fue encontrado."
  end

  def handle_standard_error(exception)
    log_error(exception)
    notify_error_tracking_service(exception)
    redirect_back fallback_location: root_path, alert: "Ocurrió un error inesperado."
  end

  def log_error(exception)
    Rails.logger.error <<~LOG
      ERROR: #{exception.class} - #{exception.message}
      Trace:
      #{exception.backtrace&.join("\n")}
    LOG
  end

  def notify_error_tracking_service(exception)
    Rollbar.error(exception, request: request, user: current_user)
  end
end
