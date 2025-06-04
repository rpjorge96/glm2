# frozen_string_literal: true

class ChangePredioNumberFromIntegerToStringInControlUnits < ActiveRecord::Migration[7.1]
  def change
    change_column :control_units, :predio_number, :string
  end
end
