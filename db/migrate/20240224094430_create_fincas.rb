class CreateFincas < ActiveRecord::Migration[7.1]
  def change
    create_table :fincas do |t|
      t.string :número
      t.string :folio
      t.string :libro
      t.string :departamento
      t.float :área
      t.string :propietario
      t.references :project, null: false, foreign_key: true

      t.timestamps
    end
  end
end
