class AddNumeroDePersonasToClients < ActiveRecord::Migration[7.1]
  def change
    add_column :clients, :número_de_personas_que_integran_grupo_familiar, :integer
  end
end
