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
class ListadoDePrecio < ApplicationRecord
  before_validation :set_default_values

  belongs_to :control_unit
  belongs_to :archivo, class_name: "ListadoDePrecioArchivo", optional: true

  monetize :precio_de_lista_cents
  monetize :contado_cents
  monetize :meses_24_cents
  monetize :enganche_cents

  def self.ransackable_attributes(_auth_object = nil)
    %w[archivo_id control_unit_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[archivo control_unit versions]
  end

  def current_price?
    archivo_id == ListadoDePrecioArchivo.order("fecha_de_listado DESC").first.id
  end

  private

  def set_default_values
    self.precio_de_lista ||= 0
    self.contado ||= 0
    self.meses_24 ||= 0
    self.enganche ||= 0
  end
end
