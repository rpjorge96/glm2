# frozen_string_literal: true

class ChangeZeroPointLocationFromStringToInteger < ActiveRecord::Migration[7.1]
  def change
    remove_column :control_units, :zero_point_location
    add_column :control_units, :zero_point_location, :integer
  end
end
