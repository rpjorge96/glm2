# frozen_string_literal: true

# == Schema Information
#
# Table name: tipo_de_identificacion_clientes
#
#  id         :bigint           not null, primary key
#  nombre     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class TipoDeIdentificacionCliente < ApplicationRecord
  has_many :clients
  validates :nombre, presence: true, uniqueness: true
end
