class AddReCompraReVentaToControlUnits < ActiveRecord::Migration[7.1]
  def change
    add_column :control_units, :re_compra_abogado, :string
    add_column :control_units, :re_compra_número_de_escritura, :string
    add_column :control_units, :re_compra_fecha_de_escritura, :date
    add_column :control_units, :re_compra_quién_otorga, :string
    add_column :control_units, :re_compra_quién_recibe, :string

    add_column :control_units, :re_venta_abogado, :string
    add_column :control_units, :re_venta_número_de_escritura, :string
    add_column :control_units, :re_venta_fecha_de_escritura, :date
    add_column :control_units, :re_venta_quién_otorga, :string
    add_column :control_units, :re_venta_quién_recibe, :string
  end
end
