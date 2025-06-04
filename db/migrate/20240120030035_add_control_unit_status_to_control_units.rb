# frozen_string_literal: true

class AddControlUnitStatusToControlUnits < ActiveRecord::Migration[7.1]
  def change
    add_reference :control_units, :control_unit_status, null: true, foreign_key: true
  end
end
