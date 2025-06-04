class CreateCities < ActiveRecord::Migration[7.1]
  def change
    create_table :cities do |t|
      t.string :country_code
      t.string :state_code
      t.string :name

      t.timestamps
    end

    add_index :cities, [:country_code, :state_code, :name], unique: true
  end
end
