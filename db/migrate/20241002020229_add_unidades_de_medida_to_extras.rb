class AddUnidadesDeMedidaToExtras < ActiveRecord::Migration[7.1]
  def change
    add_column :extras, :unidades_de_medida, :integer
  end
end
