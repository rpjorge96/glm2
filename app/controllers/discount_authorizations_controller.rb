class DiscountAuthorizationsController < ApplicationController
  before_action :set_discount_authorization, only: %i[show update]
  before_action :set_query_params, only: %i[index]

  def index
    @headers = [
      {name: "No. de Cotización", field: "quotation_reference_number", sortable: true},
      {name: "Precio", field: "sale_value"},
      {name: "Descuento", field: "discount_value", sortable: true},
      {name: "Vendedor", field: "last_edited_by_name"},
      {name: "Estado", field: "status", sortable: true}
    ]

    discount_authorizations = DiscountAuthorization.joins(:quotation)
      .select("discount_authorizations.*, quotations.reference_number AS quotation_reference_number")

    @pagy, @discount_authorizations = process_query_params(discount_authorizations)
  end

  def show
  end

  def update
    new_params = discount_authorization_params.merge(approval_user_id: current_user.id, approval_date: Time.zone.now)

    if @discount_authorization.update(new_params)
      redirect_to discount_authorization_path(@discount_authorization), notice: "La autorización de descuento ha sido actualizada exitosamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_discount_authorization
    @discount_authorization = DiscountAuthorization.find(params[:id])
  end

  def discount_authorization_params
    params.require(:discount_authorization).permit(:approval_reason, :status)
  end
end
