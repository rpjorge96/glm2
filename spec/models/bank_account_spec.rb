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
require "rails_helper"

RSpec.describe BankAccount, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
