# frozen_string_literal: true

class ChangeWritingNumberFromIntegerToStringInControlUnits < ActiveRecord::Migration[7.1]
  def change
    change_column :control_units, :writing_number, :string
  end
end
