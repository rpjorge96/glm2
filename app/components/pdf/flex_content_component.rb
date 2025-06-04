# frozen_string_literal: true

class Pdf::FlexContentComponent < ViewComponent::Base
  def initialize(title:, center_content: false, small: false, bg_color: nil)
    @title = title
    @center_content = center_content
    @small = small
    @bg_color = bg_color || "#f4f4f3"
  end
end
