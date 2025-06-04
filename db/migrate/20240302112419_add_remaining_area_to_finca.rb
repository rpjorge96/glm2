class AddRemainingAreaToFinca < ActiveRecord::Migration[7.1]
  def change
    add_column :fincas, :remaining_area, :float
  end
end
