class AddJuridicoDetailsToClients < ActiveRecord::Migration[7.1]
  def change
    add_column :clients, :denominacion_nombre_comercial, :string
    add_column :clients, :tipo_de_entidad, :string
    add_column :clients, :no_expediente_y_año, :string
    add_column :clients, :registro, :string
    add_column :clients, :folio, :string
    add_column :clients, :libro, :string
    add_column :clients, :numero_de_escritura, :string
    add_column :clients, :lugar_de_escritura, :string
    add_column :clients, :fecha_de_escritura, :date
    add_column :clients, :notario_autorizante, :string
    add_column :clients, :objeto_actividad_economica, :string
    add_column :clients, :domicilio_de_representante_legal, :string
    add_column :clients, :nit_de_representante_legal, :string
    add_column :clients, :cargo, :string
    add_column :clients, :numero_de_nombramiento, :string
    add_column :clients, :folio_de_nombramiento, :string
    add_column :clients, :libro_de_nombramiento, :string
    add_column :clients, :fecha_vigencia_del_nombramiento, :date
    add_column :clients, :años_de_vigencia_del_nombramiento, :integer
  end
end
