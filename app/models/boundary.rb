# frozen_string_literal: true

# == Schema Information
#
# Table name: boundaries
#
#  id              :bigint           not null, primary key
#  azimuth         :string
#  distance        :decimal(, )
#  neighbor        :string
#  observed_point  :integer
#  station         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  control_unit_id :bigint           not null
#
# Indexes
#
#  index_boundaries_on_control_unit_id  (control_unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (control_unit_id => control_units.id)
#
class Boundary < ApplicationRecord
  belongs_to :control_unit

  default_scope { order(:station) }
end
