class ChangeNumeroInicialAndNumeroFinalFromStringToInteger < ActiveRecord::Migration[7.1]
  def up
    # Elimina caracteres no numéricos y convierte cadenas vacías en NULL para número_inicial
    execute <<-SQL
      UPDATE control_units
      SET número_inicial = NULLIF(REGEXP_REPLACE(número_inicial, '[^0-9]', '', 'g'), '');
    SQL

    # Cambia el tipo de número_inicial a integer
    change_column :control_units, :número_inicial, "integer USING CAST(número_inicial AS integer)"

    # Repite para número_final
    execute <<-SQL
      UPDATE control_units
      SET número_final = NULLIF(REGEXP_REPLACE(número_final, '[^0-9]', '', 'g'), '');
    SQL

    change_column :control_units, :número_final, "integer USING CAST(número_final AS integer)"
  end

  def down
    # Revierte el tipo de las columnas a string
    change_column :control_units, :número_inicial, :string
    change_column :control_units, :número_final, :string
  end
end
