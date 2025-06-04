# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id                         :bigint           not null, primary key
#  bg_field_color             :string
#  code                       :string           not null
#  control_unit_code_settings :jsonb
#  days_to_book               :integer
#  departamento_estado        :string
#  description                :string
#  discarded_at               :datetime
#  final_price_color          :string
#  includes_deed_expenses     :boolean          default(FALSE)
#  internal_code              :string(4)
#  is_active                  :boolean          default(FALSE), not null
#  municipio_ciudad           :string
#  name                       :string
#  operation_initial_date     :date
#  país                       :string
#  phone                      :string
#  price_color                :string
#  propietary                 :string
#  quotation_valid_days       :integer
#  service_company            :string
#  social_media_links         :jsonb
#  title_color                :string
#  website_url                :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#
# Indexes
#
#  index_projects_on_discarded_at  (discarded_at)
#
require "rails_helper"

RSpec.describe Project, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
