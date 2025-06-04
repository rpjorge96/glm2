# frozen_string_literal: true

# == Schema Information
#
# Table name: control_units
#
#  id                                :bigint           not null, primary key
#  altura                            :string
#  area                              :decimal(10, 2)
#  area_desmembracion                :float
#  book_number                       :string
#  code                              :string           not null
#  code_values                       :jsonb
#  description                       :text
#  desmembración_abogado             :string
#  desmembración_fecha_de_escritura  :date
#  desmembración_número_de_escritura :string
#  desmembración_quién_otorga        :string
#  desmembración_quién_recibe        :string
#  discarded_at                      :datetime
#  east_location                     :string
#  finca_number                      :string
#  folio_number                      :string
#  identificacion_registral          :jsonb
#  north_location                    :string
#  plan_approved_at                  :date
#  precio_de_lista_cents             :integer
#  precio_de_lista_currency          :string
#  precio_de_lista_dollar_cents      :integer
#  precio_de_lista_dollar_currency   :string           default("USD"), not null
#  precio_de_venta_cents             :integer
#  precio_de_venta_currency          :string
#  precio_de_venta_dollar_cents      :integer
#  precio_de_venta_dollar_currency   :string           default("USD"), not null
#  predio_number                     :string
#  re_compra_abogado                 :string
#  re_compra_fecha_de_escritura      :date
#  re_compra_número_de_escritura     :string
#  re_compra_quién_otorga            :string
#  re_compra_quién_recibe            :string
#  re_venta_abogado                  :string
#  re_venta_fecha_de_escritura       :date
#  re_venta_número_de_escritura      :string
#  re_venta_quién_otorga             :string
#  re_venta_quién_recibe             :string
#  venta_abogado                     :string
#  venta_fecha_de_escritura          :date
#  venta_número_de_escritura         :string
#  venta_quién_otorga                :string
#  venta_quién_recibe                :string
#  where_is_the_book_from            :string
#  zero_point_location               :integer
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  control_unit_status_id            :bigint
#  control_unit_sub_type_id          :integer
#  control_unit_type_id              :integer
#  finca_id                          :bigint
#  project_id                        :bigint           not null
#
# Indexes
#
#  index_control_units_on_code                    (code) UNIQUE
#  index_control_units_on_control_unit_status_id  (control_unit_status_id)
#  index_control_units_on_discarded_at            (discarded_at)
#  index_control_units_on_finca_id                (finca_id)
#  index_control_units_on_project_id              (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (control_unit_status_id => control_unit_statuses.id)
#  fk_rails_...  (control_unit_sub_type_id => control_unit_sub_types.id)
#  fk_rails_...  (control_unit_type_id => control_unit_types.id)
#  fk_rails_...  (finca_id => fincas.id)
#  fk_rails_...  (project_id => projects.id)
#
require "rails_helper"

RSpec.describe ControlUnit, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
