# == Schema Information
#
# Table name: payments
#
#  id                             :bigint           not null, primary key
#  description                    :string
#  payment_type                   :integer          not null
#  quantity                       :decimal(10, 2)   not null
#  reference_number               :string
#  status                         :integer          default("created"), not null
#  transaction_date               :datetime         not null
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  bank_account_id                :bigint           not null
#  control_unit_payment_detail_id :bigint           not null
#  created_by_user_id             :bigint           not null
#  payment_method_id              :bigint           not null
#
# Indexes
#
#  index_payments_on_bank_account_id                 (bank_account_id)
#  index_payments_on_control_unit_payment_detail_id  (control_unit_payment_detail_id)
#  index_payments_on_created_by_user_id              (created_by_user_id)
#  index_payments_on_payment_method_id               (payment_method_id)
#
# Foreign Keys
#
#  fk_rails_...  (bank_account_id => bank_accounts.id)
#  fk_rails_...  (control_unit_payment_detail_id => control_unit_payment_details.id)
#  fk_rails_...  (created_by_user_id => users.id)
#  fk_rails_...  (payment_method_id => payment_methods.id)
#
class Payment < ApplicationRecord
  belongs_to :control_unit_payment_detail
  belongs_to :payment_method
  belongs_to :bank_account
  belongs_to :created_by_user, class_name: "User"

  has_one_attached :receipt

  enum payment_type: {
    down_payment: 0,
    monthly_payment: 1,
    total_cancellation: 2,
    extraordinary_payment: 3,
    others: 4
  }

  enum status: {
    created: 0,
    verified: 1,
    cancelled: 2,
    rejected: 3
  }

  validates :payment_type, :payment_method, :bank_account, :transaction_date, :quantity, presence: true
  validates :quantity, numericality: {greater_than: 0}

  before_create :generate_reference_number

  delegate :control_unit, to: :control_unit_payment_detail
  delegate :project, to: :control_unit

  private

  def generate_reference_number
    return if reference_number.present?

    project_internal_code = project.internal_code
    return unless project_internal_code

    last_reference = Payment.where("reference_number LIKE ?", "#{project_internal_code}-%")
      .order(reference_number: :desc)
      .first&.reference_number

    if last_reference
      letter_part = last_reference[-6..-5]  # e.g., 'AA' from 'PLB-AA-123'
      number_part = last_reference[-3..].to_i # e.g., 123 from 'PLB-AA-123'

      if number_part == 999
        next_letters = increment_letters(letter_part)
        raise "Reference number limit reached" unless next_letters

        next_number = 1
      else
        next_letters = letter_part
        next_number = number_part + 1
      end
    else
      next_letters = "AA"
      next_number = 1
    end

    self.reference_number = format(
      "%s-%s-%03d",
      project_internal_code,
      next_letters,
      next_number
    )
  end

  def increment_letters(current)
    return "AA" if current.nil?

    chars = current.chars
    return nil unless chars.length == 2 && chars.all? { |c| ("A".."Z").cover?(c) }

    first, second = chars

    if second == "Z"
      if first == "Z"
        return nil # End of ZZ, can't go further
      else
        first = first.next
        second = "A"
      end
    else
      second = second.next
    end

    "#{first}#{second}"
  end
end
