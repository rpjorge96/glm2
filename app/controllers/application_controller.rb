# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ErrorHandler
  include Pagy::Backend
  include QueryParams
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_paper_trail_whodunnit
  authorize_resource unless: -> { devise_controller? || %w[home configurations].include?(controller_name) }
  # check_authorization unless: :devise_controller?
  rescue_from CanCan::AccessDenied do |exception|
    if current_user.nil?
      session[:next] = request.fullpath
      redirect_to login_url, alert: "Tienes que iniciar sesión para acceder a esta página."
    else
      respond_to do |format|
        format.json { render nothing: true, status: :not_found }
        format.html { redirect_back(fallback_location: root_path, alert: exception.message) }
        format.js { render nothing: true, status: :not_found }
      end
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end

  private

  def after_sign_out_path_for(resource_or_scope) # rubocop:disable Lint/UnusedMethodArgument
    new_user_session_path
  end

  def set_query_params
    @query_params = params.permit(:sort_by, :page, :per_page)
    @sort_by = @query_params[:sort_by] || "-created_at"
    @page = @query_params[:page] || 1
    @per_page = @query_params[:per_page] || 25
  end
end
