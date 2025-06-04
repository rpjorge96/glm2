# frozen_string_literal: true

class ChangeBookNumberAndFincaNumberAndFolioNumberInControlUnitsFromIntegertoString < ActiveRecord::Migration[7.1]
  def change
    change_column :control_units, :book_number, :string
    change_column :control_units, :finca_number, :string
    change_column :control_units, :folio_number, :string
  end
end
