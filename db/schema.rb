# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_05_12_183520) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bank_accounts", force: :cascade do |t|
    t.string "bank_name"
    t.string "number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "currency"
  end

  create_table "boundaries", force: :cascade do |t|
    t.integer "station"
    t.integer "observed_point"
    t.string "azimuth"
    t.decimal "distance"
    t.string "neighbor"
    t.bigint "control_unit_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["control_unit_id"], name: "index_boundaries_on_control_unit_id"
  end

  create_table "cities", force: :cascade do |t|
    t.string "country_code"
    t.string "state_code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_code", "state_code", "name"], name: "index_cities_on_country_code_and_state_code_and_name", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.string "nombres"
    t.string "apellidos"
    t.string "dpi"
    t.date "fecha_de_nacimiento"
    t.string "nacionalidad"
    t.string "profesión_u_oficio"
    t.string "teléfono_celular"
    t.string "correo_electrónico"
    t.string "nit"
    t.string "dirección"
    t.string "ciudad"
    t.string "departamento_o_estado"
    t.string "país"
    t.string "nombre_empresa_donde_labora"
    t.string "cargo_o_puesto"
    t.string "tiempo_de_laborar"
    t.string "ingresos_mensuales_promedio"
    t.string "nombre_de_referencia1"
    t.string "parentesco_de_referencia1"
    t.string "teléfono_de_referencia1"
    t.string "dirección_de_referencia1"
    t.string "nombre_de_referencia2"
    t.string "parentesco_de_referencia2"
    t.string "teléfono_de_referencia2"
    t.string "dirección_de_referencia2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "tipo_de_identificacion_cliente_id"
    t.integer "tipo_de_cliente"
    t.integer "estado_civil"
    t.integer "género"
    t.integer "número_de_personas_que_integran_grupo_familiar"
    t.string "denominacion_nombre_comercial"
    t.string "tipo_de_entidad"
    t.string "no_expediente_y_año"
    t.string "registro"
    t.string "folio"
    t.string "libro"
    t.string "numero_de_escritura"
    t.string "lugar_de_escritura"
    t.date "fecha_de_escritura"
    t.string "notario_autorizante"
    t.string "objeto_actividad_economica"
    t.string "domicilio_de_representante_legal"
    t.string "nit_de_representante_legal"
    t.string "cargo"
    t.string "numero_de_nombramiento"
    t.string "folio_de_nombramiento"
    t.string "libro_de_nombramiento"
    t.date "fecha_vigencia_del_nombramiento"
    t.integer "años_de_vigencia_del_nombramiento"
    t.string "address"
    t.integer "contact_preference"
    t.index ["tipo_de_identificacion_cliente_id", "dpi"], name: "index_unique_tipo_identificacion_dpi", unique: true
    t.index ["tipo_de_identificacion_cliente_id"], name: "index_clients_on_tipo_de_identificacion_cliente_id"
  end

  create_table "control_unit_applicants", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.bigint "control_unit_id", null: false
    t.integer "applicant_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_control_unit_applicants_on_client_id"
    t.index ["control_unit_id"], name: "index_control_unit_applicants_on_control_unit_id"
  end

  create_table "control_unit_payment_details", force: :cascade do |t|
    t.bigint "control_unit_id"
    t.string "hookup"
    t.float "down_payment_installment"
    t.date "last_down_payment_date"
    t.integer "down_payment_installments"
    t.integer "total_installments"
    t.float "down_payment_balance"
    t.date "next_down_payment_date"
    t.float "balance"
    t.string "payment_method"
    t.float "monthly_payment"
    t.integer "balance_installments"
    t.date "start_date"
    t.float "total_balance"
    t.jsonb "extra_payments", default: []
    t.jsonb "down_payments", default: []
    t.jsonb "monthly_payments", default: []
    t.jsonb "late_payments", default: []
    t.jsonb "capital_payments", default: []
    t.jsonb "total_payments", default: []
    t.string "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["control_unit_id"], name: "index_control_unit_payment_details_on_control_unit_id"
  end

  create_table "control_unit_sale_details", force: :cascade do |t|
    t.bigint "control_unit_id", null: false
    t.bigint "applicant_1_id"
    t.bigint "applicant_2_id"
    t.string "currency"
    t.boolean "includes_deed_expenses"
    t.float "construction_area"
    t.float "garden_area"
    t.integer "parking_spaces"
    t.float "balcony_area"
    t.float "total_area"
    t.string "parking_type"
    t.date "estimated_delivery_date"
    t.float "cash_advance"
    t.float "down_payment"
    t.float "cash_advance_balance"
    t.integer "installment"
    t.float "monthly_installment"
    t.integer "maximum_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "purchase_date"
    t.float "selling_price"
    t.string "seller"
    t.float "cash_advance_interest_rate"
    t.float "balance"
    t.string "bank"
    t.string "file"
    t.string "finance_plan"
    t.integer "term"
    t.integer "payment_day"
    t.float "monthly_payment"
    t.float "annual_interest_rate"
    t.float "self_financing_interest_rate"
    t.string "remarks"
    t.integer "finance_type"
    t.string "request_number"
    t.jsonb "property_dynamic_fields"
    t.index ["applicant_1_id"], name: "index_control_unit_sale_details_on_applicant_1_id"
    t.index ["applicant_2_id"], name: "index_control_unit_sale_details_on_applicant_2_id"
    t.index ["control_unit_id"], name: "index_control_unit_sale_details_on_control_unit_id"
  end

  create_table "control_unit_statuses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "color"
  end

  create_table "control_unit_sub_type_projects", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "control_unit_sub_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "precio_cents"
    t.string "precio_currency"
    t.integer "precio_dollar_cents"
    t.string "precio_dollar_currency", default: "USD", null: false
    t.index ["control_unit_sub_type_id"], name: "idx_on_control_unit_sub_type_id_422e348ac9"
    t.index ["project_id", "control_unit_sub_type_id"], name: "unique_project_and_control_unit_sub_type", unique: true
    t.index ["project_id"], name: "index_control_unit_sub_type_projects_on_project_id"
  end

  create_table "control_unit_sub_types", force: :cascade do |t|
    t.string "name"
    t.bigint "control_unit_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.integer "lotes_minimos"
    t.integer "passive_maintenance_fee_cents"
    t.integer "active_maintenance_fee_cents"
    t.string "passive_maintenance_fee_currency"
    t.string "active_maintenance_fee_currency"
    t.jsonb "subtype_data", default: []
    t.string "img4_desc"
    t.string "img2_desc"
    t.string "img3_desc"
    t.decimal "active_maintenance_fee_dollars"
    t.decimal "passive_maintenance_fee_dollars"
    t.decimal "garden_area", precision: 10, scale: 2
    t.decimal "balconies_terrace_area", precision: 10, scale: 2
    t.integer "parking_spaces"
    t.string "parking_type"
    t.jsonb "subtype_variable_data", default: {}
    t.index ["control_unit_type_id"], name: "index_control_unit_sub_types_on_control_unit_type_id"
  end

  create_table "control_unit_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "control_unit_types_projects", force: :cascade do |t|
    t.bigint "control_unit_type_id", null: false
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["control_unit_type_id", "project_id"], name: "index_control_unit_type_project_uniqueness", unique: true
    t.index ["control_unit_type_id"], name: "index_control_unit_types_projects_on_control_unit_type_id"
    t.index ["project_id"], name: "index_control_unit_types_projects_on_project_id"
  end

  create_table "control_unit_types_projects_extras", force: :cascade do |t|
    t.bigint "control_unit_types_project_id", null: false
    t.bigint "extra_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["control_unit_types_project_id"], name: "idx_on_control_unit_types_project_id_f556e6c56f"
    t.index ["extra_id", "control_unit_types_project_id"], name: "index_on_extra_and_control_unit_and_project", unique: true
    t.index ["extra_id"], name: "index_control_unit_types_projects_extras_on_extra_id"
  end

  create_table "control_units", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.string "code", null: false
    t.text "description"
    t.string "finca_number"
    t.string "folio_number"
    t.string "book_number"
    t.string "where_is_the_book_from"
    t.date "plan_approved_at"
    t.string "predio_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.integer "zero_point_location"
    t.string "north_location"
    t.string "east_location"
    t.decimal "area", precision: 10, scale: 2
    t.bigint "control_unit_status_id"
    t.string "desmembración_abogado"
    t.string "desmembración_número_de_escritura"
    t.date "desmembración_fecha_de_escritura"
    t.string "desmembración_quién_otorga"
    t.string "desmembración_quién_recibe"
    t.string "venta_abogado"
    t.string "venta_número_de_escritura"
    t.date "venta_fecha_de_escritura"
    t.string "venta_quién_otorga"
    t.string "venta_quién_recibe"
    t.bigint "finca_id"
    t.float "area_desmembracion"
    t.string "altura"
    t.integer "precio_de_lista_cents"
    t.string "precio_de_lista_currency"
    t.integer "precio_de_venta_cents"
    t.string "precio_de_venta_currency"
    t.string "re_compra_abogado"
    t.string "re_compra_número_de_escritura"
    t.date "re_compra_fecha_de_escritura"
    t.string "re_compra_quién_otorga"
    t.string "re_compra_quién_recibe"
    t.string "re_venta_abogado"
    t.string "re_venta_número_de_escritura"
    t.date "re_venta_fecha_de_escritura"
    t.string "re_venta_quién_otorga"
    t.string "re_venta_quién_recibe"
    t.integer "precio_de_lista_dollar_cents"
    t.string "precio_de_lista_dollar_currency", default: "USD", null: false
    t.integer "precio_de_venta_dollar_cents"
    t.string "precio_de_venta_dollar_currency", default: "USD", null: false
    t.jsonb "identificacion_registral"
    t.jsonb "code_values", default: {}
    t.integer "control_unit_type_id"
    t.integer "control_unit_sub_type_id"
    t.index ["code"], name: "index_control_units_on_code", unique: true
    t.index ["control_unit_status_id"], name: "index_control_units_on_control_unit_status_id"
    t.index ["discarded_at"], name: "index_control_units_on_discarded_at"
    t.index ["finca_id"], name: "index_control_units_on_finca_id"
    t.index ["project_id"], name: "index_control_units_on_project_id"
  end

  create_table "country_settings", force: :cascade do |t|
    t.string "códigos", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "discount_authorizations", force: :cascade do |t|
    t.bigint "quotation_id", null: false
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.integer "sale_value"
    t.integer "discount_value"
    t.string "approval_reason"
    t.integer "approval_user_id"
    t.datetime "approval_date"
    t.index ["quotation_id"], name: "index_discount_authorizations_on_quotation_id"
  end

  create_table "extras", force: :cascade do |t|
    t.string "name"
    t.string "extrable_type"
    t.bigint "extrable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "precio_cents"
    t.string "precio_currency"
    t.integer "precio_dollar_cents"
    t.string "precio_dollar_currency", default: "USD", null: false
    t.string "description"
    t.integer "unidades_de_medida"
    t.index ["extrable_type", "extrable_id", "name"], name: "index_extras_on_extrable_and_name", unique: true
    t.index ["extrable_type", "extrable_id"], name: "index_extras_on_extrable"
  end

  create_table "financial_entities", force: :cascade do |t|
    t.string "name"
    t.decimal "annual_interest_rate"
    t.decimal "down_payment_percentage"
    t.integer "financing_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "minimum_down_payment_cents"
    t.string "minimum_down_payment_currency"
    t.integer "maximum_years_to_finance"
    t.integer "minimum_down_payment_dollar_cents"
    t.string "minimum_down_payment_dollar_currency", default: "USD", null: false
    t.integer "months_to_pay_down_payment", default: 1
    t.decimal "porcentaje_pago_inicial"
    t.jsonb "notes", default: {}, null: false
  end

  create_table "fincas", force: :cascade do |t|
    t.string "número"
    t.string "folio"
    t.string "libro"
    t.string "departamento"
    t.float "área"
    t.string "propietario"
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "remaining_area"
    t.index ["project_id"], name: "index_fincas_on_project_id"
  end

  create_table "import_logs", force: :cascade do |t|
    t.json "log_message"
    t.string "file_name"
    t.integer "import_type"
    t.string "importable_type", null: false
    t.bigint "importable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["importable_type", "importable_id"], name: "index_import_logs_on_importable"
  end

  create_table "listado_de_precio_archivos", force: :cascade do |t|
    t.string "nombre"
    t.date "fecha_de_listado"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "listado_de_precios", force: :cascade do |t|
    t.bigint "control_unit_id", null: false
    t.integer "precio_de_lista_cents"
    t.integer "contado_cents"
    t.integer "meses_24_cents"
    t.integer "enganche_cents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "archivo_id"
    t.index ["archivo_id"], name: "index_listado_de_precios_on_archivo_id"
    t.index ["control_unit_id"], name: "index_listado_de_precios_on_control_unit_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "method_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "control_unit_payment_detail_id", null: false
    t.integer "payment_type", null: false
    t.bigint "payment_method_id", null: false
    t.bigint "bank_account_id", null: false
    t.string "reference_number"
    t.datetime "transaction_date", null: false
    t.decimal "quantity", precision: 10, scale: 2, null: false
    t.string "description"
    t.integer "status", default: 0, null: false
    t.bigint "created_by_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bank_account_id"], name: "index_payments_on_bank_account_id"
    t.index ["control_unit_payment_detail_id"], name: "index_payments_on_control_unit_payment_detail_id"
    t.index ["created_by_user_id"], name: "index_payments_on_created_by_user_id"
    t.index ["payment_method_id"], name: "index_payments_on_payment_method_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.bigint "role_id"
    t.string "subject_class"
    t.integer "subject_id"
    t.string "action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["role_id"], name: "index_permissions_on_role_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "discarded_at"
    t.string "code", null: false
    t.date "operation_initial_date"
    t.string "país"
    t.string "departamento_estado"
    t.string "municipio_ciudad"
    t.string "phone"
    t.string "website_url"
    t.boolean "includes_deed_expenses", default: false
    t.integer "quotation_valid_days"
    t.jsonb "social_media_links"
    t.integer "days_to_book"
    t.string "internal_code", limit: 4
    t.jsonb "control_unit_code_settings", default: "{\"numero_inicial\":false,\"sufijos\":false,\"re_compra\":false,\"re_venta\":false}"
    t.string "title_color"
    t.string "price_color"
    t.string "final_price_color"
    t.string "bg_field_color"
    t.string "propietary"
    t.string "service_company"
    t.boolean "is_active", default: false, null: false
    t.index ["discarded_at"], name: "index_projects_on_discarded_at"
  end

  create_table "projects_sale_request_templates", id: false, force: :cascade do |t|
    t.bigint "sale_request_template_id", null: false
    t.bigint "project_id", null: false
    t.index ["project_id"], name: "index_projects_sale_request_templates_on_project_id"
    t.index ["sale_request_template_id"], name: "idx_on_sale_request_template_id_689543f4cb"
  end

  create_table "projects_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "project_id", null: false
  end

  create_table "quotations", force: :cascade do |t|
    t.string "client_name"
    t.string "client_phone"
    t.string "client_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "quotation_params"
    t.integer "down_payment_months"
    t.string "reference_number"
    t.datetime "pdf_generated_at"
    t.integer "client_id"
  end

  create_table "reserves", force: :cascade do |t|
    t.integer "quantity"
    t.integer "receipt_number"
    t.bigint "quotation_id", null: false
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reference_number"
    t.bigint "user_id"
    t.index ["client_id"], name: "index_reserves_on_client_id"
    t.index ["quotation_id"], name: "index_reserves_on_quotation_id"
    t.index ["reference_number"], name: "index_reserves_on_reference_number", unique: true
    t.index ["user_id"], name: "index_reserves_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "max_allowed_discount_percentage", precision: 5, scale: 2, default: "0.0"
    t.integer "max_days_extend_reservation"
    t.integer "max_days_extend_quotation"
  end

  create_table "sale_request_templates", force: :cascade do |t|
    t.string "name"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sale_requests", force: :cascade do |t|
    t.bigint "applicant_1_id", null: false
    t.bigint "applicant_2_id"
    t.string "reference_number"
    t.integer "state", default: 0, null: false
    t.bigint "sale_request_template_id", null: false
    t.bigint "quotation_id", null: false
    t.bigint "created_by_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["applicant_1_id"], name: "index_sale_requests_on_applicant_1_id"
    t.index ["applicant_2_id"], name: "index_sale_requests_on_applicant_2_id"
    t.index ["created_by_user_id"], name: "index_sale_requests_on_created_by_user_id"
    t.index ["quotation_id"], name: "index_sale_requests_on_quotation_id"
    t.index ["sale_request_template_id"], name: "index_sale_requests_on_sale_request_template_id"
  end

  create_table "tipo_de_identificacion_clientes", force: :cascade do |t|
    t.string "nombre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: ""
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.string "username"
    t.bigint "role_id"
    t.string "phone"
    t.string "name"
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.json "object"
    t.json "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "boundaries", "control_units"
  add_foreign_key "clients", "tipo_de_identificacion_clientes"
  add_foreign_key "control_unit_applicants", "clients"
  add_foreign_key "control_unit_applicants", "control_units"
  add_foreign_key "control_unit_payment_details", "control_units"
  add_foreign_key "control_unit_sale_details", "clients", column: "applicant_1_id"
  add_foreign_key "control_unit_sale_details", "clients", column: "applicant_2_id"
  add_foreign_key "control_unit_sale_details", "control_units"
  add_foreign_key "control_unit_sub_type_projects", "control_unit_sub_types"
  add_foreign_key "control_unit_sub_type_projects", "projects"
  add_foreign_key "control_unit_sub_types", "control_unit_types"
  add_foreign_key "control_unit_types_projects", "control_unit_types"
  add_foreign_key "control_unit_types_projects", "projects"
  add_foreign_key "control_unit_types_projects_extras", "control_unit_types_projects"
  add_foreign_key "control_unit_types_projects_extras", "extras"
  add_foreign_key "control_units", "control_unit_statuses"
  add_foreign_key "control_units", "control_unit_sub_types"
  add_foreign_key "control_units", "control_unit_types"
  add_foreign_key "control_units", "fincas"
  add_foreign_key "control_units", "projects"
  add_foreign_key "discount_authorizations", "quotations"
  add_foreign_key "fincas", "projects"
  add_foreign_key "listado_de_precios", "control_units"
  add_foreign_key "listado_de_precios", "listado_de_precio_archivos", column: "archivo_id"
  add_foreign_key "payments", "bank_accounts"
  add_foreign_key "payments", "control_unit_payment_details"
  add_foreign_key "payments", "payment_methods"
  add_foreign_key "payments", "users", column: "created_by_user_id"
  add_foreign_key "permissions", "roles"
  add_foreign_key "reserves", "clients"
  add_foreign_key "reserves", "quotations"
  add_foreign_key "reserves", "users"
  add_foreign_key "sale_requests", "clients", column: "applicant_1_id"
  add_foreign_key "sale_requests", "clients", column: "applicant_2_id"
  add_foreign_key "sale_requests", "quotations"
  add_foreign_key "sale_requests", "sale_request_templates"
  add_foreign_key "sale_requests", "users", column: "created_by_user_id"
  add_foreign_key "users", "roles"
end
