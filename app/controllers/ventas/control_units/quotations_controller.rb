# frozen_string_literal: true

module Ventas
  module ControlUnits
    class QuotationsController < ApplicationController
      include ActiveStorage::SetCurrent

      before_action :get_clients_info, only: %i[new edit]
      before_action :set_quotation, only: %i[show edit update destroy pdf]
      before_action :set_quotation_params, only: %i[show edit pdf]
      before_action :set_show_info, only: %i[show]
      before_action :set_max_allowed_discount_percentage, only: %i[new edit]
      before_action :set_query_params, only: %i[index]
      after_action :check_discount_authorization, only: %i[create update]
      after_action :set_pdf_update_at, only: %i[pdf]

      def index
        @headers = [
          {name: "No. de Cotización", field: "reference_number", sortable: true},
          {name: "Nombre Cliente", field: "client_name", sortable: true},
          {name: "Fecha de Creación", field: "created_at", sortable: true},
          {name: "Fecha de Actualización", field: "updated_at", sortable: true}
        ]

        @q = Quotation.all.ransack(params[:q])
        @quotations = @q.result

        @pagy, @quotations = process_query_params(@quotations)
      end

      def show
        respond_to do |format|
          format.html
          format.pdf do
            render pdf: "Cotización_#{@quotation.client_name}_#{@quotation.created_at.strftime("%d-%m-%Y")}",
              template: "ventas/control_units/quotations/show_pdf", formats: [:html]
          end
        end
      end

      def new
        @quotation = Quotation.new(quotation_params: {control_units: []}.to_json)
        @financial_entities = FinancialEntity.all
        @control_unit_codes = params[:control_unit_codes] || []
        @control_units_months_to_cession_hash = {}
        @control_units_extras_hash = {}
        @control_units_custom_payments_hash = {}
        @control_units_custom_down_payment_hash = {}
        @custom_house = params[:custom_house]

        set_control_units

        return unless @custom_house.present?

        project_id = nil
        custom_house = JSON.parse(@custom_house)
        price = custom_house["price"].to_f
        price_dollar = custom_house["price_dollar"].to_f
        custom_house_lots = custom_house["lots"].map do |lot_code|
          control_unit = ControlUnit.find_by(code: lot_code)
          project_id = control_unit.project.id if project_id.nil?
          price += control_unit.precio_de_lista.to_f
          price_dollar += control_unit.precio_de_lista_dollar.to_f
          {
            code: control_unit.code
          }
        end

        # Esto debe ajustarse para que tome los extras del proyecto y tipo de la casa customizada.
        extras = get_extras_for_custom_house_id(custom_house["subtype_project_hash"].values.first, project_id)

        @control_units << {
          id: custom_house["name"],
          code: custom_house["name"],
          price:,
          price_dollar:,
          lots: custom_house_lots,
          extras: custom_house["types"].each_with_object({}) do |type, hash|
            hash[type] = extras[type].map do |extra|
              {
                id: extra.id,
                name: extra.name,
                price: extra.precio.to_f,
                price_dollar: extra.precio_dollar.to_f,
                apply: false,
                quantity: 1
              }
            end
          end,
          types: custom_house["types"],
          subtype_project_hash: custom_house["subtype_project_hash"],
          is_custom_house: true
        }

        @control_unit_codes << custom_house["name"]
      end

      def create
        @quotation = Quotation.new(quotation_params)
        respond_to do |format|
          if @quotation.save
            format.html do
              redirect_to ventas_quotation_url(@quotation), notice: "La cotización fue creada exitosamente.", turbolinks: true
            end
          else
            format.html { render :new, status: :unprocessable_entity }
          end
        end
      end

      def edit
        @financial_entities = FinancialEntity.all
      end

      def update
        respond_to do |format|
          if @quotation.update(quotation_params)
            @quotation.purge_pdf
            format.html do
              redirect_to ventas_quotation_url(@quotation), notice: "La cotización fue actualizada exitosamente.", turbolinks: true
            end
          else
            format.html { render :edit, status: :unprocessable_entity }
          end
        end
      end

      def destroy
        respond_to do |format|
          if @quotation.destroy
            format.html { redirect_to ventas_quotations_url, notice: "La cotización fue eliminada con éxito." }
            format.json { head :no_content }
          else
            format.html do
              redirect_to ventas_quotations_url,
                alert: "La cotización no se puede eliminar."
            end
          end
        end
      end

      def calculator
        @quotation = Quotation.new
        @financial_entities = FinancialEntity.all
        @calculator_only = true
      end

      def pdf
        @quotation.generate_pdf

        respond_to do |format|
          format.html
          format.pdf do
            redirect_to @quotation.pdf.url, allow_other_host: true
          end
        end
      rescue => e
        Rails.logger.error("Error generating PDF: #{e.message} #{e.backtrace}")
        Rollbar.error(e, "Error generating PDF: #{e.message}", {quotation_id: @quotation.id})
        redirect_to ventas_quotations_url(@quotation),
          alert: "Ocurrio un error al generar el PDF. Contacte a soporte indicando el error y el No. de Cotizacion ##{@quotation.reference_number}"
      end

      def send_email_pdf
        quotation = Quotation.find(params[:quotation_id])

        QuotationMailer.send_quotation_email(quotation).deliver_now

        redirect_back(fallback_location: ventas_quotations_url, notice: "La cotización fue enviada exitosamente.")
      rescue => e
        redirect_back(fallback_location: ventas_quotations_url, alert: "Error al enviar la cotización: #{e.message}")
      end

      private

      def get_clients_info
        @clients = Client.select(:id, :tipo_de_cliente, :nombres, :apellidos, :dpi, :denominacion_nombre_comercial, :nit, :teléfono_celular, :correo_electrónico).order(id: :asc)
        @clients = @clients.map do |client|
          display_text = if client.tipo_de_cliente == "Jurídico"
            client.nit.present? ? "#{client.denominacion_nombre_comercial} - #{client.nit}" : client.denominacion_nombre_comercial
          else
            client.dpi.present? ? "#{client.nombres} #{client.apellidos} - #{client.dpi}" : "#{client.nombres} #{client.apellidos}"
          end
          client.attributes.merge(display_text: display_text)
        end
      end

      def set_show_info
        @quotation_params = quotation_parsed_params
        set_control_units
        check_custom_house(@quotation_params)
        set_extras_break_down
        set_control_units_break_down
        set_lots_break_down
        set_custom_payments_break_down
      end

      def set_quotation
        @quotation = Quotation.find(params[:id])
      end

      def set_control_unit
        @control_unit = ControlUnit.find(params[:control_unit_id])
      end

      def quotation_params
        params.require(:quotation).permit(:client_id, :client_name, :client_phone, :client_email, :quotation_params,
          :down_payment_months)
      end

      def pdf_filename
        "#{@quotation.reference_number}_#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}"
      end

      def set_quotation_params
        @parsed_quotation_params = quotation_parsed_params
        @control_unit_codes = @parsed_quotation_params["control_units"].map { |cu| cu["code"] }
        @control_units_extras_hash = @parsed_quotation_params["control_units"].each_with_object({}) do |cu, hash|
          hash[cu["id"]] = if cu["is_custom_house"]
            cu["types"].each_with_object({}) do |type, type_hash|
              type_hash[type] = cu["extras"][type].each_with_object({}) do |extra, extras_hash|
                extras_hash[extra["id"]] = {
                  "apply" => extra["apply"],
                  "quantity" => extra["quantity"] || 1
                }
              end
            end
          else
            cu["extras"].each_with_object({}) do |extra, extras_hash|
              extras_hash[extra["id"]] = {
                "apply" => extra["apply"],
                "quantity" => extra["quantity"] || 1
              }
            end
          end
        end
        @control_units_months_to_cession_hash = @parsed_quotation_params["control_units"].each_with_object({}) do |cu, hash|
          hash[cu["id"]] = cu["months_to_cession"] || 1
        end
        @control_units_custom_payments_hash = @parsed_quotation_params["control_units"].each_with_object({}) do |cu, hash|
          hash[cu["id"]] = cu["custom_payments"] || {}
        end
        @control_units_custom_down_payment_hash = @parsed_quotation_params["control_units"].each_with_object({}) do |cu, hash|
          hash[cu["id"]] = cu["custom_down_payment"] || {}
        end

        set_control_units
        check_custom_house(@parsed_quotation_params)
      end

      def set_control_units
        @control_units ||= ControlUnit.where(code: @control_unit_codes).map do |control_unit|
          {
            id: control_unit.id,
            code: control_unit.code,
            price: control_unit.precio_de_lista.to_f,
            price_dollar: control_unit.precio_de_lista_dollar.to_f,
            months_to_cession: @control_units_months_to_cession_hash[control_unit.id],
            extras: (Extra.for_project_and_control_unit_type(control_unit.project.id,
              control_unit.control_unit_type_id) + control_unit.extras).map do |extra|
                      {
                        id: extra.id,
                        name: extra.name,
                        price: extra.precio.to_f,
                        price_dollar: extra.precio_dollar.to_f,
                        apply: @control_units_extras_hash.dig(control_unit.id, extra.id, "apply"),
                        quantity: @control_units_extras_hash.dig(control_unit.id, extra.id, "quantity")
                      }
                    end,
            custom_payments: @control_units_custom_payments_hash[control_unit.id],
            custom_down_payment: @control_units_custom_down_payment_hash[control_unit.id],
            discount: if @parsed_quotation_params.nil? || @parsed_quotation_params["control_units"].nil?
                        0
                      else
                        @parsed_quotation_params["control_units"]&.find { |cu| cu["code"] == control_unit.code }&.dig("discount") || 0
                      end
          }
        end
      end

      def check_custom_house(parsed_quotation_params)
        custom_house = parsed_quotation_params["control_units"].find { |cu| cu["is_custom_house"] }
        return unless custom_house

        @custom_house = {
          id: custom_house["code"],
          code: custom_house["code"],
          price: custom_house["price"],
          price_dollar: custom_house["price_dollar"],
          lots: custom_house["lots"],
          extras: custom_house["types"].each_with_object({}) do |type, hash|
            hash[type] = custom_house["extras"][type].map do |extra|
              {
                id: extra["id"],
                name: extra["name"],
                price: extra["price"],
                price_dollar: extra["price_dollar"],
                apply: extra["apply"],
                quantity: extra["quantity"]
              }
            end
          end,
          is_custom_house: true,
          types: custom_house["types"],
          subtype_project_hash: custom_house["subtype_project_hash"],
          custom_payments: @control_units_custom_payments_hash[custom_house["code"]],
          custom_down_payment: @control_units_custom_down_payment_hash[custom_house["code"]]
        }

        @control_units << @custom_house
      end

      def set_control_units_break_down
        @control_units_break_down = []
        @quotation_params["control_units"].each do |cu|
          is_custom_house = cu["is_custom_house"]
          control_unit = ControlUnit.find_by(code: cu["code"])
          next if !is_custom_house && !control_unit

          if is_custom_house
            lots = cu["lots"].map do |lot|
              ControlUnit.find_by(code: lot["code"])
            end

            @project ||= lots.first.project

            control_unit_sub_type_project = ControlUnitSubTypeProject.find(cu["subtype_project_hash"].values.first)
            subtype = ControlUnitSubType.find(control_unit_sub_type_project.control_unit_sub_type_id)

            @control_units_break_down << {
              "code" => cu["code"],
              "area" => lots.sum { |lot| lot&.area&.positive? ? lot&.area : 0 },
              "area_de_construccion" => 0, # TODO: Add area de construccion
              "project" => @project.name,
              "type" => "Unificacion de Lotes",
              "subtype" => subtype.name,
              "subtype_description" => subtype.description,
              "lots_total_price" => lots.compact.sum { |lot| lot.precio_de_lista.to_i },
              "subtype_object" => subtype
            }

          else
            @project ||= control_unit.project
            @type = ControlUnitType.find_by(id: control_unit.control_unit_type_id.presence)
            @sub_type = ControlUnitSubType.find_by(id: control_unit.control_unit_sub_type_id.presence)

            @control_units_break_down << {
              "code" => cu["code"],
              "area" => control_unit.area,
              "area_de_construccion" => 0, # TODO: Add area de construccion
              "project" => control_unit.project.name,
              "type" => @type&.name,
              "subtype" => @sub_type&.name,
              "subtype_description" => @sub_type&.description,
              "subtype_object" => @sub_type
            }
          end
        end
      end

      def set_extras_break_down
        @extras_break_down = {}
        @quotation_params["control_units"].each do |cu|
          extras = (cu["is_custom_house"] ? cu["extras"] : cu["extras"] || {})
          if cu["is_custom_house"]
            extras.each do |subtype, extra_list|
              @extras_break_down[subtype] = []
              extra_list.each do |extra|
                process_extra(cu["code"], extra, subtype)
              end
            end
          else
            @extras_break_down[cu["code"]] = []
            extras.each do |extra|
              process_extra(cu["code"], extra)
            end
          end
        end
        @extras_break_down
      end

      def process_extra(control_unit_code, extra, subtype = nil)
        return unless extra["apply"]

        price = (@quotation_params["currency"] == "GTQ") ? extra["price"] : extra["price_dollar"]
        data = {
          "control_unit_code" => control_unit_code,
          "price" => format("%.2f", price),
          "quantity" => extra["quantity"],
          "total" => format("%.2f", price.to_f * extra["quantity"].to_i),
          "control_unit_subtype" => subtype || extra["control_unit_subtype"],
          "name" => extra["name"]
        }

        if Extra.exists?(extra["id"])
          extra_object = Extra.find(extra["id"])
          data["description"] = extra_object.description
        end

        name = subtype || control_unit_code
        @extras_break_down[name] << data
      end

      def set_lots_break_down
        @lots_break_down = []
        @quotation_params["control_units"].each do |cu|
          next unless cu["is_custom_house"]

          sub_type = ControlUnitSubType.find_by(name: cu["code"])

          @lots_break_down << {
            "sub_type_name" => cu["code"],
            "sub_type_description" => sub_type&.description,
            "lots" => cu["lots"].map do |lot|
              control_unit = ControlUnit.find_by(code: lot["code"])

              price = if @quotation_params["currency"] == "GTQ"
                "Q #{format("%.2f", control_unit&.precio_de_lista.to_f)}"
              else
                "$ #{format("%.2f", control_unit&.precio_de_lista_dollar.to_f)}"
              end

              {
                "code" => lot["code"],
                "area" => control_unit&.area,
                "price" => price
              }
            end
          }
        end
      end

      def set_custom_payments_break_down
        @custom_payments_break_down = []
        @quotation_params["control_units"].each do |cu|
          (cu["custom_payments"] || {}).each do |key, value|
            financial_entity = FinancialEntity.find(key)
            next unless financial_entity

            @custom_payments_break_down << {
              "control_unit_code" => cu["code"],
              "financial_entity" => financial_entity,
              "months" => value
            }
          end
        end
      end

      def get_extras_for_custom_house_id(control_unit_subtype_project_id, project_id)
        subtypes = ControlUnitSubTypeProject.where(id: control_unit_subtype_project_id)
        extras = {}
        subtypes.each do |subtype|
          extras[subtype.control_unit_sub_type.name] = [] unless extras.key?(subtype.control_unit_sub_type.name)
          extras[subtype.control_unit_sub_type.name] += subtype.extras
          extras[subtype.control_unit_sub_type.name] += Extra.for_project_and_control_unit_type(project_id,
            subtype.control_unit_sub_type.control_unit_type.id)
        end
        extras
      end

      def set_max_allowed_discount_percentage
        @max_allowed_discount_percentage = current_user.role.max_allowed_discount_percentage
      end

      def check_discount_authorization
        parsed_quotation_params = @quotation.parsed_params

        return if parsed_quotation_params["discount_status"].nil?

        @discount_authorization = DiscountAuthorization.find_or_initialize_by(quotation: @quotation)

        return unless @discount_authorization.new_record? || discount_or_sale_value_changed

        update_discount_values
      end

      def set_pdf_update_at
        time = Time.now
        @quotation.update(pdf_generated_at: time, updated_at: time)
      end

      def discount_or_sale_value_changed
        @discount_authorization.discount_value != quotation_parsed_params["discount_total"] || @discount_authorization.sale_value != quotation_parsed_params["sale_total"]
      end

      def update_discount_values
        @discount_authorization.update!(discount_value: quotation_parsed_params["discount_total"],
          sale_value: quotation_parsed_params["sale_total"],
          comment: quotation_parsed_params["discount_authorization_comment"],
          status: :pending)
      end

      def quotation_parsed_params
        @quotation.parsed_params
      end
    end
  end
end
