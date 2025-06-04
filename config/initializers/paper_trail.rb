# frozen_string_literal: true

PaperTrail.config.version_limit = nil
PaperTrail.serializer = PaperTrail::Serializers::JSON

# PaperTrail::Version.class_eval do
#   def changed_attributes_with_values
#     @changed_attributes_with_values ||= begin
#       changes = JSON.parse(object_changes || '{}', symbolize_names: true)
#       changes.transform_values do |value|
#         { from: value[0], to: value[1] }
#       end
#     end
#   end
# end
