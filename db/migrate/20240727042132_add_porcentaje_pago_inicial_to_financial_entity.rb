class AddPorcentajePagoInicialToFinancialEntity < ActiveRecord::Migration[7.1]
  def change
    add_column :financial_entities, :porcentaje_pago_inicial, :decimal
  end
end
