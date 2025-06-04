# frozen_string_literal: true

# == Schema Information
#
# Table name: permissions
#
#  id            :bigint           not null, primary key
#  action        :string
#  subject_class :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  role_id       :bigint
#  subject_id    :integer
#
# Indexes
#
#  index_permissions_on_role_id  (role_id)
#
# Foreign Keys
#
#  fk_rails_...  (role_id => roles.id)
#
require "rails_helper"

RSpec.describe Permission, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
