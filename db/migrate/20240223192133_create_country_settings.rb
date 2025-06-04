class CreateCountrySettings < ActiveRecord::Migration[7.1]
  def change
    create_table :country_settings do |t|
      t.string :códigos, array: true, default: []

      t.timestamps
    end

    CountrySetting.create(:códigos => ["GT", "US"])
  end
end
