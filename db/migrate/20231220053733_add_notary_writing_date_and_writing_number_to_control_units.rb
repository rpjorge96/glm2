# frozen_string_literal: true

class AddNotaryWritingDateAndWritingNumberToControlUnits < ActiveRecord::Migration[7.1]
  def change
    add_column :control_units, :notary, :string
    add_column :control_units, :writing_date, :date
    add_column :control_units, :writing_number, :integer
  end
end
