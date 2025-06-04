# frozen_string_literal: true

module Roles
  class PermissionsController < ApplicationController
    before_action :set_role, only: %i[index new create]

    def index
      @permissions = @role.permissions
    end

    def new
      Rails.application.eager_load!
      # Nombres de los modelos a excluir, como strings o símbolos
      model_names_to_exclude = %w[CountrySetting ImportLog ControlUnitSetting City Quotation]

      # Convierte los nombres a clases, asumiendo que están definidos en el toplevel namespace
      models_to_exclude = model_names_to_exclude.map(&:constantize)

      # Filtra los modelos
      @models = ApplicationRecord.descendants.reject { |model| models_to_exclude.include?(model) }
    end

    def create
      subject_class, action_values = permission_params.to_h.first
      action, value = action_values.first

      if value == "1"
        @role.permissions.find_or_create_by(subject_class:, action:)
      elsif value == "0"
        @role.permissions.find_by(subject_class:, action:)&.destroy
      end
      redirect_to new_role_permission_path(@role), notice: "Permiso actualizado"
    rescue ActiveRecord::RecordInvalid => e
      redirect_to new_role_permission_path(@role), alert: "Error al actualizar permiso: #{e.message}"
    end

    private

    def set_role
      @role = Role.find(params[:role_id])
    end

    def permission_params
      params.require(:permissions).permit!
    end
  end
end
