# frozen_string_literal: true

class Pdf::TableFooterComponent < ViewComponent::Base
  def initialize(data:, bg_color: nil, title_bg_color: nil, header_bg_color: nil, custom_class: nil)
    @data = data
    @bg_color = bg_color
    @title_bg_color = title_bg_color
    @header_bg_color = header_bg_color
    @custom_class = custom_class
  end
end
