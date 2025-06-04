class AddPrecioDeListaCentsToControlUnits < ActiveRecord::Migration[7.1]
  def change
    add_monetize :control_units,
      :precio_de_lista,
      amount: {null: true, default: nil},
      currency: {null: true, default: nil}
  end
end
