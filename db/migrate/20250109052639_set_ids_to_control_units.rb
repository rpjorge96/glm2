class SetIdsToControlUnits < ActiveRecord::Migration[7.1]
  def up
    add_column :control_units, :control_unit_type_id, :integer
    add_column :control_units, :control_unit_sub_type_id, :integer

    execute <<-SQL
      UPDATE control_units
      SET control_unit_type_id = control_unit_types.id
      FROM control_unit_types, control_unit_sub_types
      WHERE control_units.control_unit_type = control_unit_types.name
        AND control_units.control_unit_sub_type = control_unit_sub_types.name
        AND control_unit_types.id = control_unit_sub_types.control_unit_type_id;
    SQL

    execute <<-SQL
      UPDATE control_units
      SET control_unit_sub_type_id = control_unit_sub_types.id
      FROM control_unit_types, control_unit_sub_types
      WHERE control_units.control_unit_type = control_unit_types.name
        AND control_units.control_unit_sub_type = control_unit_sub_types.name
        AND control_unit_types.id = control_unit_sub_types.control_unit_type_id;
    SQL

    add_foreign_key :control_units, :control_unit_types, column: :control_unit_type_id
    add_foreign_key :control_units, :control_unit_sub_types, column: :control_unit_sub_type_id

    remove_column :control_units, :control_unit_type
    remove_column :control_units, :control_unit_sub_type
  end

  def down
    add_column :control_units, :control_unit_type, :string
    add_column :control_units, :control_unit_sub_type, :string

    execute <<-SQL
      UPDATE control_units
      SET control_unit_type = control_unit_types.name,
          control_unit_sub_type = control_unit_sub_types.name
      FROM control_unit_types, control_unit_sub_types
      WHERE control_units.control_unit_type_id = control_unit_types.id
        AND control_units.control_unit_sub_type_id = control_unit_sub_types.id
        AND control_unit_types.id = control_unit_sub_types.control_unit_type_id;
    SQL

    remove_foreign_key :control_units, column: :control_unit_type_id
    remove_foreign_key :control_units, column: :control_unit_sub_type_id

    remove_column :control_units, :control_unit_type_id
    remove_column :control_units, :control_unit_sub_type_id
  end
end
