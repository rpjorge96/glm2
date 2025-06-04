class AddDiscardedAtToControlUnits < ActiveRecord::Migration[7.1]
  def change
    add_column :control_units, :discarded_at, :datetime
    add_index :control_units, :discarded_at
  end
end
