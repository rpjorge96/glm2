# frozen_string_literal: true

# == Schema Information
#
# Table name: listado_de_precios
#
#  id                    :bigint           not null, primary key
#  contado_cents         :integer
#  enganche_cents        :integer
#  meses_24_cents        :integer
#  precio_de_lista_cents :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  archivo_id            :bigint
#  control_unit_id       :bigint           not null
#
# Indexes
#
#  index_listado_de_precios_on_archivo_id       (archivo_id)
#  index_listado_de_precios_on_control_unit_id  (control_unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (archivo_id => listado_de_precio_archivos.id)
#  fk_rails_...  (control_unit_id => control_units.id)
#
require "rails_helper"

RSpec.describe ListadoDePrecio, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
