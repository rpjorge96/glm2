class AddLotesMinimosToControlUnitSubType < ActiveRecord::Migration[7.1]
  def change
    add_column :control_unit_sub_types, :lotes_minimos, :integer
  end
end
