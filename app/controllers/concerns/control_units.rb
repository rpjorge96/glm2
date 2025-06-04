# frozen_string_literal: true

# app/controllers/concerns/control_units.rb

module ControlUnits
  extend ActiveSupport::Concern

  private

  def shared_params
    [
      :project_id, :code, :description, :zero_point_location,
      :finca_number, :folio_number, :book_number, :where_is_the_book_from,
      :registered_at, :predio_number, :plan_approved_at,
      :north_location, :east_location, :altura, :area, :scale, :plan,
      :notary, :writing_date, :writing_number, :control_unit_status_id,
      :desmembración_abogado, :desmembración_fecha_de_escritura, :desmembración_número_de_escritura,
      :desmembración_quién_otorga, :desmembración_quién_recibe, :venta_abogado, :venta_fecha_de_escritura,
      :venta_número_de_escritura, :venta_quién_otorga, :venta_quién_recibe,
      :derrotero, :otro, :finca_id, :area_desmembracion, :control_unit_type_id, :control_unit_sub_type_id,
      :precio_de_lista, :precio_de_venta,
      :re_venta_abogado, :re_venta_fecha_de_escritura, :re_venta_número_de_escritura,
      :re_venta_quién_otorga, :re_venta_quién_recibe, :re_compra_abogado, :re_compra_fecha_de_escritura,
      :re_compra_número_de_escritura, :re_compra_quién_otorga, :re_compra_quién_recibe,
      :precio_de_lista_dollar, :precio_de_venta_dollar,
      {identificacion_registral: %i[
        descripcion
        numero_de_finca
        numero_de_folio
        numero_de_libro
        de_donde_es_el_libro
      ]}
    ]
  end

  def sale_detail_params
    [
      :applicant_1_id, :applicant_2_id, :applicant_1_display_text, :applicant_2_display_text, :purchase_date, :selling_price,
      :seller, :includes_deed_expenses, :currency, :construction_area, :garden_area, :parking_spaces, :balcony_area, :total_area,
      :parking_type, :estimated_delivery_date, :cash_advance, :cash_advance_interest_rate, :down_payment, :cash_advance_balance,
      :installment, :monthly_installment, :maximum_day, :finance_type, :bank, :request_number, :file, :balance, :finance_plan, :term,
      :payment_day, :monthly_payment, :annual_interest_rate, :self_financing_interest_rate, :remarks, :key1, :key2, :key3,
      :key4, :key5, :key6, :value1, :value2, :value3, :value4, :value5, :value6, :_destroy
    ]
  end

  def payment_detail_params
    [
      :user_id, :hookup, :down_payment_installment, :last_down_payment_date, :down_payment_installments, :total_installments,
      :down_payment_balance, :next_down_payment_date, :balance, :payment_method, :monthly_payment, :balance_installments,
      :start_date, :total_balance, :remarks, :_destroy, {extra_payments: %i[date receipt_number quantity client_id updated_at]},
      {down_payments: %i[date receipt_number quantity client_id updated_at]}, {late_payments: %i[date receipt_number quantity client_id updated_at]},
      {monthly_payments: %i[date receipt_number quantity late_payment interest capital others client_id updated_at]},
      {capital_payments: %i[date receipt_number quantity client_id updated_at]}, {total_payments: %i[date receipt_number quantity client_id updated_at]}
    ]
  end

  def control_unit_params_with_code_values
    new_params = params.require(:control_unit).permit(shared_params +
                                                        [control_unit_sale_detail_attributes: sale_detail_params] +
                                                        [control_unit_payment_detail_attributes: payment_detail_params])
    code_values = {}
    @project.parsed_control_unit_code_settings.each do |k, v|
      next unless v

      if k == "sufijos"
        code_values[:suffix_custom] = params[:control_unit][:suffix_custom]
        code_values[:suffix_standard] = params[:control_unit][:suffix_standard]
      end

      code_values[k] = params[:control_unit][k]
    end

    new_params[:code_values] = code_values
    new_params
  end
end
