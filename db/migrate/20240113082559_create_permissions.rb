# frozen_string_literal: true

class CreatePermissions < ActiveRecord::Migration[7.1]
  def change
    create_table :permissions do |t|
      t.references :role, null: true, foreign_key: true
      t.string :subject_class
      t.integer :subject_id
      t.string :action

      t.timestamps
    end
  end
end
