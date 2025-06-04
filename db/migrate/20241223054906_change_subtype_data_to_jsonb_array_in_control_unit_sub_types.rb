class ChangeSubtypeDataToJsonbArrayInControlUnitSubTypes < ActiveRecord::Migration[7.1]
  def up
    execute <<-SQL
      UPDATE control_unit_sub_types
      SET subtype_data = (
        SELECT jsonb_agg(jsonb_build_object(key, value))
        FROM jsonb_each_text(subtype_data) AS kv(key, value)
      )
      WHERE subtype_data IS NOT NULL;
    SQL

    change_column :control_unit_sub_types, :subtype_data, :jsonb, using: "subtype_data::JSONB", default: []
  end

  def change
    change_column :control_unit_sub_types, :subtype_data, :jsonb, using: "subtype_data::JSONB", default: []
  end
end
