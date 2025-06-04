# frozen_string_literal: true

module Projects
  class FincasController < ApplicationController
    before_action :set_project, only: %i[index new update]

    def index
      @fincas = @project.fincas
    end

    def new
      count = params[:count].to_i
      if count.zero? && @project.fincas.empty?
        redirect_back fallback_location: root_path, alert: "Se requieren al menos 1 para crear una finca"
      else
        build_fincas(count)
      end
    end

    def update
      update_params = project_params
      respond_to do |format|
        if @project.update(update_params)
          if update_params[:fincas_attributes].to_h.size < @project.fincas.count
            to_destroy = Finca.unscoped.where(project_id: @project.id).order(id: :desc).limit(@project.fincas.count - update_params[:fincas_attributes].to_h.size)
            to_destroy.destroy_all
            @project.reload
          end
          format.html do
            redirect_to project_url(@project), notice: "El proyecto se actualizó exitosamente.", format: :html
          end
          format.json { render :show, status: :ok, location: @project }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def project_params
      params.require(:project).permit(fincas_attributes: %i[id número folio libro departamento propietario área
        project_id _destroy])
    end

    def build_fincas(count)
      if @project.fincas.empty?
        new_or_add_build_fincas(count)
      else
        update_build_fincas(count)
      end
    end

    def new_or_add_build_fincas(count_or_add)
      original_count = @project.fincas.count || 0
      count = count_or_add - original_count
      count.times do
        @project.fincas.build
      end
    end

    def remove_build_fincas(count)
      @remove_count = count
    end

    def update_build_fincas(count)
      original_count = @project.fincas.count
      if count > original_count
        new_or_add_build_fincas(count)
      elsif count == original_count
        nil
      else
        remove_build_fincas(count)
      end
    end

    def set_project
      id = params[:project_id] || params[:id]
      @project = Project.find(id)
    end
  end
end
