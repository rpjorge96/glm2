# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq-status/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  namespace :checking_account do
    resources :home, only: %i[index]
    resources :cashboxes, only: :index
    resources :consolidations, only: :index
  end

  namespace :audits do
    get "user", to: "users#index"
    get "user/:id", to: "users#show", as: "user_audit"
  end

  resources :bank_accounts
  resources :payment_methods
  resources :discount_authorizations, only: %i[index show update]

  namespace :ventas do
    resources :listado_de_precio_archivos
    resources :listado_de_precios, only: %i[index]
    resources :home, only: %i[index]
    resources :control_units, only: %i[index] do
      resources :quotations, module: "control_units"
    end
    resources :quotations, module: "control_units" do
      member do
        get "pdf", to: "quotations#pdf", as: :pdf
      end
      get "send_email_pdf/:quotation_id", to: "quotations#send_email_pdf", as: :send_email_pdf, on: :collection
    end

    get "calculator", to: "control_units/quotations#calculator", as: :calculator

    resources :reserves
  end

  resources :control_unit_types
  resources :control_unit_sub_types do
    scope module: :control_unit_sub_types do
      resources :control_unit_sub_type_projects, only: %i[index]
    end
  end
  resources :control_unit_sub_type_projects, only: %i[show update] do
    scope module: :control_unit_sub_type_projects do
      resources :extras, only: %i[index new create]
    end
  end
  resources :extras, only: %i[index show new edit create update destroy]
  get "control_unit_settings/subtypes", to: "control_unit_settings#subtypes", as: :subtypes

  resources :boundaries, only: %i[show edit update destroy]
  resources :country_settings, only: %i[index]
  resource :country_settings, only: %i[update]
  get "country_settings/subdivisions", to: "country_settings#subdivisions", as: :subdivisions
  get "country_settings/cities", to: "country_settings#cities", as: :cities
  get "projects/:project_id/control_units/export_template", to: "projects/control_units#export_template",
    as: :export_template_control_units
  resources :control_units, only: %i[show edit update destroy] do
    get "versions", on: :member
    member do
      put "boundaries", to: "control_units/boundaries#update"
    end
    collection do
      get :export_form
      post :export
    end
    resources :boundaries, shallow: true, only: %i[new index], module: :control_units
  end
  resources :projects do
    collection do
      get :export_form
      post :export
    end
    member do
      put "fincas", to: "projects/fincas#update"
    end
    resources :control_units, shallow: true, only: %i[new create index], module: :projects
    resources :fincas, shallow: true, only: %i[new index], module: :projects

    post "control_units/import_create", to: "projects/control_units#import_create", as: :import_create_control_units
    post "control_units/import_update", to: "projects/control_units#import_update", as: :import_update_control_units
  end
  resources :clients

  scope :configurations do
    # get '/', to: 'configurations#home', as: :configurations
    resources :users do
      get "versions", on: :member
    end
    resources :control_unit_statuses
    resources :roles do
      resources :permissions, shallow: true, only: %i[new create index], module: :roles
    end
    resources :financial_entities
    resources :sale_request_templates do
      get "/preview", to: "sale_request_templates#preview", as: :preview, on: :member
    end
  end
  namespace :configurations do
    resources :tipo_de_identificacion_clientes
  end
  # resources :users
  # resources :control_units do
  #   resources :boundaries
  # end
  devise_for :users, controllers: {
    sessions: "users/sessions"
  }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check
  root to: "home#index"

  # Defines the root path route ("/")
  # root "posts#index"
end
