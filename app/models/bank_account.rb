# == Schema Information
#
# Table name: bank_accounts
#
#  id         :bigint           not null, primary key
#  bank_name  :string
#  currency   :integer
#  number     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class BankAccount < ApplicationRecord
  validates :bank_name, presence: true
  validates :number, uniqueness: {message: "Ya existe una cuenta de banco con ese número de cuenta"}

  enum currency: {USD: 1, GTQ: 2}
end
