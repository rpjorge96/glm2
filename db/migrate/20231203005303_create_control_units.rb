# frozen_string_literal: true

class CreateControlUnits < ActiveRecord::Migration[7.1]
  def change
    create_table :control_units do |t|
      t.references :project, null: false, foreign_key: true
      t.string :code, null: false, index: {unique: true}
      t.text :description
      t.integer :control_unit_type
      t.string :zero_point_location
      t.integer :finca_number
      t.integer :folio_number
      t.integer :book_number
      t.string :where_is_the_book_from
      t.date :registered_at
      t.integer :ccc_number
      t.date :plan_approved_at
      t.string :coordinates
      t.integer :predio_number

      t.timestamps
    end
  end
end
