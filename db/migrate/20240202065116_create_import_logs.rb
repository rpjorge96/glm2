class CreateImportLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :import_logs do |t|
      t.json :log_message
      t.string :file_name
      t.integer :import_type
      t.references :importable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
