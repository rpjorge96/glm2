class PaymentMethodsController < ApplicationController
  before_action :set_payment_method, only: %i[show edit update destroy]

  def index
    @payment_methods = PaymentMethod.order(:method_type)
  end

  def show
    @payment_method = PaymentMethod.find(params[:id])
  end

  def new
    @payment_method = PaymentMethod.new
  end

  def create
    @payment_method = PaymentMethod.new(payment_method_params)
    if @payment_method.save
      redirect_to payment_method_url(@payment_method), notice: "Método de pago agregado con éxito."
    else
      flash.now[:alert] = "Método de pago no pudo ser creado."
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @payment_method = PaymentMethod.find(params[:id])
  end

  def update
    if @payment_method.update(payment_method_params)
      redirect_to payment_method_url(@payment_method), notice: "Método de pago se actualizó exitosamente."
    else
      flash.now[:alert] = "Método de pago no pudo ser actualizado."
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @payment_method.destroy
    redirect_to payment_methods_url, notice: "Método de pago eliminado con éxito."
  end

  private

  def set_payment_method
    @payment_method = PaymentMethod.find(params[:id])
  end

  def payment_method_params
    params.require(:payment_method).permit(:method_type)
  end
end
