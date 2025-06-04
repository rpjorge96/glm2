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
class ListadoDePrecioArchivo < ApplicationRecord
  has_many :listado_de_precios, foreign_key: "archivo_id", dependent: :destroy

  has_one_attached :archivo

  def self.last_fecha_de_listado
    order("fecha_de_listado DESC").first&.fecha_de_listado
  end
end
