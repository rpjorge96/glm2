# frozen_string_literal: true

class CountrySettingsController < ApplicationController
  before_action :set_country_settings, only: %i[index update]

  def index
    @countries_in_spanish = Country.all.map do |country|
      [country.translations[:es], country.alpha2]
    end
  end

  def update
    countries_code_array = @country_settings.códigos
    to_update = params.require(:countries).permit!.to_h.first
    if to_update[1] == "1"
      countries_code_array << to_update[0]
    else
      countries_code_array.delete(to_update[0])
    end

    @country_settings.update(:códigos => countries_code_array)

    redirect_to country_settings_path, notice: "Países actualizados"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to country_settings_path, alert: "Error al actualizar países: #{e.message}"
  end

  def subdivisions
    country = Country.find_country_by_any_name(params[:country])
    subdivisions = country.subdivision_names
    render json: subdivisions
  end

  def cities
    country = Country.find_country_by_any_name(params[:country])
    subdivision = params[:subdivision]
    subdivision_code = country.find_subdivision_by_name(subdivision).code
    cs_cities = CS.cities(subdivision_code, country.alpha2) || []
    db_cities = City.where(country_code: country.alpha2, state_code: subdivision_code).pluck(:name) || []
    cities = (cs_cities + db_cities).uniq

    render json: cities
  end

  private

  def set_country_settings
    @country_settings = CountrySetting.all.first
  end
end
