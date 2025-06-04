# frozen_string_literal: true

module CountrySettingsHelper
  def check_if_country_is_selected(country_code)
    @country_settings.códigos.include?(country_code)
  end
end
