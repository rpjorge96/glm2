# frozen_string_literal: true

# == Schema Information
#
# Table name: fincas
#
#  id             :bigint           not null, primary key
#  departamento   :string
#  folio          :string
#  libro          :string
#  número         :string
#  propietario    :string
#  remaining_area :float
#  área           :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  project_id     :bigint           not null
#
# Indexes
#
#  index_fincas_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
require "rails_helper"

RSpec.describe Finca, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
