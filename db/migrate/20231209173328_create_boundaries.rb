# frozen_string_literal: true

class CreateBoundaries < ActiveRecord::Migration[7.1]
  def change
    create_table :boundaries do |t|
      t.integer :station
      t.integer :observed_point
      t.string :azimuth
      t.float :distance
      t.string :neighbor
      t.references :control_unit, null: false, foreign_key: true

      t.timestamps
    end
  end
end
