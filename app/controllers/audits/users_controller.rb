# frozen_string_literal: true

module Audits
  class UsersController < ApplicationController
    before_action :set_user, only: %i[show]

    def index
      search_params = params.permit(:page, :format,
        q: [:username_or_role_name_cont])

      @q = User.ransack(params[:q])
      @query = search_params[:q]

      @pagy, @users = pagy_countless(@q.result.includes(:role))
    end

    def show
      # user_creations_for_model = PaperTrail::Version.where(whodunnit: user_id.to_s, event: 'create', item_type: 'NombreDelModelo')
      set_ransack_papertrail
      @q = PaperTrail::Version.ransack(nil)
      @q.whodunnit_eq = @user.id.to_s # Filtra por el ID del usuario

      # Si se busca por una fecha específica
      if params[:q] && params[:q][:created_at_eq]
        date = params[:q][:created_at_eq].to_date
        @q.created_at_gteq = date.beginning_of_day
        @q.created_at_lteq = date.end_of_day
      end

      @user_changes = @q.result.order(created_at: :desc)
    end

    private

    def set_ransack_papertrail
      @set_ransack_papertrail ||= PaperTrail::Version.class_eval do
        def self.ransackable_attributes(_auth_object = nil)
          %w[whodunnit event object object_changes created_at]
        end
      end
    end

    def set_user
      @user = User.find(params[:id])
    end
  end
end
