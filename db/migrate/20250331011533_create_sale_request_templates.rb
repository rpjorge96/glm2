class CreateSaleRequestTemplates < ActiveRecord::Migration[7.1]
  def change
    create_table :sale_request_templates do |t|
      t.string :name
      t.text :body
      t.references :control_unit_status, null: false, foreign_key: true

      t.timestamps
    end
  end

  create_join_table :sale_request_templates, :projects do |t|
    t.index :sale_request_template_id
    t.index :project_id
  end
end
