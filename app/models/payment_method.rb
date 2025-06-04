# == Schema Information
#
# Table name: payment_methods
#
#  id          :bigint           not null, primary key
#  method_type :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class PaymentMethod < ApplicationRecord
  validates :method_type, presence: true, uniqueness: {case_sensitive: false, message: "Ya existe un método de pago con ese nombre"}
end
