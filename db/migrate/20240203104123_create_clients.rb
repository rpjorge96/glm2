# frozen_string_literal: true

class CreateClients < ActiveRecord::Migration[7.1]
  def change
    create_table :clients do |t|
      t.string :nombres
      t.string :apellidos
      t.string :dpi
      t.date :fecha_de_nacimiento
      t.string :estado_civil
      t.string :nacionalidad
      t.string :profesión_u_oficio
      t.string :género
      t.string :teléfono_celular
      t.string :correo_electrónico
      t.string :número_de_personas_que_integran_grupo_familiar
      t.string :nit
      t.string :dirección
      t.string :ciudad
      t.string :departamento_o_estado
      t.string :país
      t.string :nombre_empresa_donde_labora
      t.string :cargo_o_puesto
      t.string :tiempo_de_laborar
      t.string :ingresos_mensuales_promedio
      t.string :nombre_de_referencia1
      t.string :parentesco_de_referencia1
      t.string :teléfono_de_referencia1
      t.string :dirección_de_referencia1
      t.string :nombre_de_referencia2
      t.string :parentesco_de_referencia2
      t.string :teléfono_de_referencia2
      t.string :dirección_de_referencia2

      t.timestamps
    end
  end
end
