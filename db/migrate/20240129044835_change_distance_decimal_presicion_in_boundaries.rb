# frozen_string_literal: true

class ChangeDistanceDecimalPresicionInBoundaries < ActiveRecord::Migration[7.1]
  def change
    change_column :boundaries, :distance, :decimal
  end
end
