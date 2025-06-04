# frozen_string_literal: true

class AddDesmembracionAndVentaFieldsToControlUnits < ActiveRecord::Migration[7.1]
  def change
    add_column :control_units, :desmembración_abogado, :string
    add_column :control_units, :desmembración_número_de_escritura, :string
    add_column :control_units, :desmembración_fecha_de_escritura, :date
    add_column :control_units, :desmembración_quién_otorga, :string
    add_column :control_units, :desmembración_quién_recibe, :string
    add_column :control_units, :venta_abogado, :string
    add_column :control_units, :venta_número_de_escritura, :string
    add_column :control_units, :venta_fecha_de_escritura, :date
    add_column :control_units, :venta_quién_otorga, :string
    add_column :control_units, :venta_quién_recibe, :string
  end
end
