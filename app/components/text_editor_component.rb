# frozen_string_literal: true

class TextEditorComponent < ViewComponent::Base
  def initialize(id:, fallback_id:, initial_content: nil, options: nil)
    @id = id
    @fallback_id = fallback_id
    @initial_content = initial_content || ""
    @options = options || %w[bold italic underline strike highlight size color font left_align center_align right_align justify image list ordered_list hr]
  end
end
