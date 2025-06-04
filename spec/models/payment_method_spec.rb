# == Schema Information
#
# Table name: payment_methods
#
#  id          :bigint           not null, primary key
#  method_type :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "rails_helper"

RSpec.describe PaymentMethod, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
