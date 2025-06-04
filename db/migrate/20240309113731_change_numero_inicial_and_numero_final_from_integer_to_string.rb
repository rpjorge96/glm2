class ChangeNumeroInicialAndNumeroFinalFromIntegerToString < ActiveRecord::Migration[7.1]
  def change
    change_column :control_units, :número_inicial, :string
    change_column :control_units, :número_final, :string
  end
end
