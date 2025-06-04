# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    prepend_before_action :check_captcha, only: [:create]
    # before_action :configure_sign_in_params, only: [:create]

    def create
      super do |resource|
        # Redirigir según el rol del usuario después del login
        if resource.role.name == "Admin"
          redirect_to root_path and return
        elsif resource.role.name == "Ventas"
          redirect_to ventas_home_index_path and return
        end
      end
    end

    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    # def create
    #   super
    # end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end

    private

    def check_captcha
      return if !ENV.fetch("RECAPTCHA_ENABLED",
        nil).present? || verify_recaptcha(action: "login",
          minimum_score: ENV.fetch(
            "RECAPTCHA_MINIMUM_SCORE", 0.5
          ).to_d)

      self.resource = resource_class.new sign_in_params

      respond_with_navigational(resource) do
        flash.discard(:recaptcha_error) # We need to discard flash to avoid showing it on the next page reload
        render :new
      end
    end
  end
end
