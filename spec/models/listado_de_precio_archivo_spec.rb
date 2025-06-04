# frozen_string_literal: true

# == Schema Information
#
# Table name: listado_de_precio_archivos
#
#  id               :bigint           not null, primary key
#  fecha_de_listado :date
#  nombre           :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require "rails_helper"

RSpec.describe ListadoDePrecioArchivo, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
