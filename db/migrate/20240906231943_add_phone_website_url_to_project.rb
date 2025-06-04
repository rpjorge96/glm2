class AddPhoneWebsiteUrlToProject < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :phone, :string
    add_column :projects, :website_url, :string
  end
end
