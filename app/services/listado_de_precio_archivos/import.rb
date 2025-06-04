# frozen_string_literal: true

module ListadoDePrecioArchivos
  class Import < ApplicationService
    def initialize(listado_de_precio_archivo)
      @listado_de_precio_archivo = listado_de_precio_archivo
    end

    def call
      @listado_de_precio_archivo.archivo.open do |file|
        spreadsheet = Roo::Spreadsheet.open(file.path, extension: :xlsx)
        header = spreadsheet.row(1)

        (2..spreadsheet.last_row).each do |i|
          row = [header, spreadsheet.row(i)].transpose.to_h

          control_unit = ControlUnit.find_by(code: row["Codigo"])
          next unless control_unit

          listado_de_precio = ListadoDePrecio.new

          listado_de_precio.control_unit_id = control_unit.id
          listado_de_precio.precio_de_lista = row["Precio de lista"]
          # listado_de_precio.contado = row['Contado']
          # listado_de_precio.meses_24 = row['24 meses']
          # listado_de_precio.enganche = row['Enganche']
          listado_de_precio.archivo = @listado_de_precio_archivo

          listado_de_precio.save!

          next unless ListadoDePrecioArchivo.order("fecha_de_listado DESC").first == @listado_de_precio_archivo

          control_unit.user_role = "admin"
          control_unit.precio_de_lista = listado_de_precio.precio_de_lista
          control_unit.save!
        end
      end
    end
  end
end
