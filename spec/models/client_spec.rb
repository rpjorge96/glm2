# frozen_string_literal: true

# == Schema Information
#
# Table name: clients
#
#  id                                             :bigint           not null, primary key
#  address                                        :string
#  apellidos                                      :string
#  años_de_vigencia_del_nombramiento              :integer
#  cargo                                          :string
#  cargo_o_puesto                                 :string
#  ciudad                                         :string
#  contact_preference                             :integer
#  correo_electrónico                             :string
#  denominacion_nombre_comercial                  :string
#  departamento_o_estado                          :string
#  dirección                                      :string
#  dirección_de_referencia1                       :string
#  dirección_de_referencia2                       :string
#  domicilio_de_representante_legal               :string
#  dpi                                            :string
#  estado_civil                                   :integer
#  fecha_de_escritura                             :date
#  fecha_de_nacimiento                            :date
#  fecha_vigencia_del_nombramiento                :date
#  folio                                          :string
#  folio_de_nombramiento                          :string
#  género                                         :integer
#  ingresos_mensuales_promedio                    :string
#  libro                                          :string
#  libro_de_nombramiento                          :string
#  lugar_de_escritura                             :string
#  nacionalidad                                   :string
#  nit                                            :string
#  nit_de_representante_legal                     :string
#  no_expediente_y_año                            :string
#  nombre_de_referencia1                          :string
#  nombre_de_referencia2                          :string
#  nombre_empresa_donde_labora                    :string
#  nombres                                        :string
#  notario_autorizante                            :string
#  numero_de_escritura                            :string
#  numero_de_nombramiento                         :string
#  número_de_personas_que_integran_grupo_familiar :integer
#  objeto_actividad_economica                     :string
#  parentesco_de_referencia1                      :string
#  parentesco_de_referencia2                      :string
#  país                                           :string
#  profesión_u_oficio                             :string
#  registro                                       :string
#  teléfono_celular                               :string
#  teléfono_de_referencia1                        :string
#  teléfono_de_referencia2                        :string
#  tiempo_de_laborar                              :string
#  tipo_de_cliente                                :integer
#  tipo_de_entidad                                :string
#  created_at                                     :datetime         not null
#  updated_at                                     :datetime         not null
#  tipo_de_identificacion_cliente_id              :bigint
#
# Indexes
#
#  index_clients_on_tipo_de_identificacion_cliente_id  (tipo_de_identificacion_cliente_id)
#  index_unique_tipo_identificacion_dpi                (tipo_de_identificacion_cliente_id,dpi) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (tipo_de_identificacion_cliente_id => tipo_de_identificacion_clientes.id)
#
require "rails_helper"

RSpec.describe Client, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
