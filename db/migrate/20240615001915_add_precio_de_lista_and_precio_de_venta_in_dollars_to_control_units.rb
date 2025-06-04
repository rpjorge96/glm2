class AddPrecioDeListaAndPrecioDeVentaInDollarsToControlUnits < ActiveRecord::Migration[7.1]
  def change
    add_monetize :control_units,
      :precio_de_lista_dollar,
      amount: {null: true, default: nil},
      currency: {null: false, default: "USD"}

    add_monetize :control_units,
      :precio_de_venta_dollar,
      amount: {null: true, default: nil},
      currency: {null: false, default: "USD"}
  end
end
