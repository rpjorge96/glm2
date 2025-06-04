# == Schema Information
#
# Table name: reserves
#
#  id               :bigint           not null, primary key
#  quantity         :integer
#  receipt_number   :integer
#  reference_number :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  client_id        :bigint           not null
#  quotation_id     :bigint           not null
#  user_id          :bigint
#
# Indexes
#
#  index_reserves_on_client_id         (client_id)
#  index_reserves_on_quotation_id      (quotation_id)
#  index_reserves_on_reference_number  (reference_number) UNIQUE
#  index_reserves_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (client_id => clients.id)
#  fk_rails_...  (quotation_id => quotations.id)
#  fk_rails_...  (user_id => users.id)
#
class Reserve < ApplicationRecord
  belongs_to :quotation
  belongs_to :client
  belongs_to :user

  validates :quantity, presence: true, numericality: {only_integer: true}
  validates :receipt_number, presence: true, numericality: {only_integer: true}

  after_create :set_reference_number

  def self.ransackable_attributes(_auth_object = nil)
    %w[reference_number quantity]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[user client]
  end

  private

  def set_reference_number
    project_code = quotation.project.internal_code
    padded_id = id.to_s.rjust(5, "0")
    year_suffix = created_at.year.to_s[-2, 2]
    ref_number = "#{project_code}-#{padded_id}-#{year_suffix}-RE"
    update_column(:reference_number, ref_number)
  end
end
