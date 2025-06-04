# frozen_string_literal: true

# == Schema Information
#
# Table name: import_logs
#
#  id              :bigint           not null, primary key
#  file_name       :string
#  import_type     :integer
#  importable_type :string           not null
#  log_message     :json
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  importable_id   :bigint           not null
#
# Indexes
#
#  index_import_logs_on_importable  (importable_type,importable_id)
#
class ImportLog < ApplicationRecord
  belongs_to :importable, polymorphic: true

  enum import_type: {:Creación => 0, :Actualización => 1}
end
