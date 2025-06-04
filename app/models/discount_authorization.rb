# == Schema Information
#
# Table name: discount_authorizations
#
#  id               :bigint           not null, primary key
#  approval_date    :datetime
#  approval_reason  :string
#  comment          :string
#  discount_value   :integer
#  sale_value       :integer
#  status           :integer          default("pending")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  approval_user_id :integer
#  quotation_id     :bigint           not null
#
# Indexes
#
#  index_discount_authorizations_on_quotation_id  (quotation_id)
#
# Foreign Keys
#
#  fk_rails_...  (quotation_id => quotations.id)
#
class DiscountAuthorization < ApplicationRecord
  belongs_to :quotation
  belongs_to :approval_user, class_name: "User", optional: true
  validates :comment, presence: true

  enum status: {pending: 0, approved: 1, unapproved: 2}

  after_update :update_quotation_discount_status

  delegate :currency, to: :quotation
  delegate :last_edited_by_name, to: :quotation
  delegate :reference_number, to: :quotation, prefix: true

  def pending?
    status == "pending"
  end

  def approved?
    status == "approved"
  end

  def unapproved?
    status == "unapproved"
  end

  def translated_status
    I18n.t("activerecord.attributes.discount_authorization.statuses.#{status}")
  end

  private

  def update_quotation_discount_status
    quotation_params = quotation.parsed_params
    quotation_params["discount_status"] = status
    quotation.update(quotation_params: quotation_params.to_json)
  end
end
