# == Schema Information
#
# Table name: control_unit_applicants
#
#  id              :bigint           not null, primary key
#  applicant_type  :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  client_id       :bigint           not null
#  control_unit_id :bigint           not null
#
# Indexes
#
#  index_control_unit_applicants_on_client_id        (client_id)
#  index_control_unit_applicants_on_control_unit_id  (control_unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (control_unit_id => control_units.id)
#
class ControlUnitApplicant < ApplicationRecord
  belongs_to :client
  belongs_to :control_unit

  validates :client_id, presence: true
  validates :control_unit_id, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[id client_id control_unit_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[client control_unit]
  end
end
