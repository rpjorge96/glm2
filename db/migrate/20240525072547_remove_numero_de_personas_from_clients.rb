class RemoveNumeroDePersonasFromClients < ActiveRecord::Migration[7.1]
  def change
    remove_column :clients, :número_de_personas_que_integran_grupo_familiar, :string
  end
end
