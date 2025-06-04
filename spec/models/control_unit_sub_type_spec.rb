# frozen_string_literal: true

# == Schema Information
#
# Table name: control_unit_sub_types
#
#  id                               :bigint           not null, primary key
#  active_maintenance_fee_cents     :integer
#  active_maintenance_fee_currency  :string
#  active_maintenance_fee_dollars   :decimal(, )
#  balconies_terrace_area           :decimal(10, 2)
#  description                      :string
#  garden_area                      :decimal(10, 2)
#  img2_desc                        :string
#  img3_desc                        :string
#  img4_desc                        :string
#  lotes_minimos                    :integer
#  name                             :string
#  parking_spaces                   :integer
#  parking_type                     :string
#  passive_maintenance_fee_cents    :integer
#  passive_maintenance_fee_currency :string
#  passive_maintenance_fee_dollars  :decimal(, )
#  subtype_data                     :jsonb
#  subtype_variable_data            :jsonb
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  control_unit_type_id             :bigint           not null
#
# Indexes
#
#  index_control_unit_sub_types_on_control_unit_type_id  (control_unit_type_id)
#
# Foreign Keys
#
#  fk_rails_...  (control_unit_type_id => control_unit_types.id)
#
require "rails_helper"

RSpec.describe ControlUnitSubType, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
