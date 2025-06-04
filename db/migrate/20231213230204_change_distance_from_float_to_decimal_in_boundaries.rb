# frozen_string_literal: true

class ChangeDistanceFromFloatToDecimalInBoundaries < ActiveRecord::Migration[7.1]
  def up
    change_column :boundaries, :distance, :decimal, precision: 10, scale: 2
  end

  def down
    change_column :boundaries, :distance, :float
  end
end
