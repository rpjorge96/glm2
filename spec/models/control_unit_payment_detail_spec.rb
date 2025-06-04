# == Schema Information
#
# Table name: control_unit_payment_details
#
#  id                        :bigint           not null, primary key
#  balance                   :float
#  balance_installments      :integer
#  capital_payments          :jsonb
#  down_payment_balance      :float
#  down_payment_installment  :float
#  down_payment_installments :integer
#  down_payments             :jsonb
#  extra_payments            :jsonb
#  hookup                    :string
#  last_down_payment_date    :date
#  late_payments             :jsonb
#  monthly_payment           :float
#  monthly_payments          :jsonb
#  next_down_payment_date    :date
#  payment_method            :string
#  remarks                   :string
#  start_date                :date
#  total_balance             :float
#  total_installments        :integer
#  total_payments            :jsonb
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  control_unit_id           :bigint
#
# Indexes
#
#  index_control_unit_payment_details_on_control_unit_id  (control_unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (control_unit_id => control_units.id)
#
require "rails_helper"

RSpec.describe ControlUnitPaymentDetail, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
