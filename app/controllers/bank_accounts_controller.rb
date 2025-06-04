class BankAccountsController < ApplicationController
  before_action :set_bank_account, only: %i[show edit update destroy]

  def index
    @bank_accounts = BankAccount.order(:bank_name)
  end

  def show
    @bank_account = BankAccount.find(params[:id])
  end

  def new
    @bank_account = BankAccount.new
  end

  def create
    @bank_account = BankAccount.new(bank_account_params)
    if @bank_account.save
      redirect_to @bank_account, notice: "Cuenta guardada con éxito."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @bank_account = BankAccount.find(params[:id])
  end

  def update
    @bank_account = BankAccount.find(params[:id])
    if @bank_account.update(bank_account_params)
      redirect_to @bank_account, notice: "Cuenta modificada con éxito."
    else
      render :edit
    end
  end

  def destroy
    @bank_account = BankAccount.find(params[:id])
    @bank_account.destroy
    redirect_to bank_accounts_url, notice: "Cuenta eliminada con éxito."
  end

  private

  def set_bank_account
    @bank_account = BankAccount.find(params[:id])
  end

  def bank_account_params
    params.require(:bank_account).permit(:bank_name, :number, :currency)
  end
end
