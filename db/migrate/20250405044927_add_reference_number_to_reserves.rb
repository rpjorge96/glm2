class AddReferenceNumberToReserves < ActiveRecord::Migration[7.1]
  def change
    add_column :reserves, :reference_number, :string
    add_index :reserves, :reference_number, unique: true
  end
end
