class AddPrecioToExtras < ActiveRecord::Migration[7.1]
  def change
    add_monetize :extras,
      :precio,
      amount: {null: true, default: nil},
      currency: {null: true, default: nil}

    add_monetize :extras,
      :precio_dollar,
      amount: {null: true, default: nil},
      currency: {null: false, default: "USD"}
  end
end
