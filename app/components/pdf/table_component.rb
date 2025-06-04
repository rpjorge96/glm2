# frozen_string_literal: true

class Pdf::TableComponent < ViewComponent::Base
  def initialize(data:, title: nil, bg_color: nil, title_bg_color: nil, header_bg_color: nil, custom_class: nil)
    @title = title
    @data = data
    @bg_color = bg_color
    @title_bg_color = title_bg_color
    @header_bg_color = header_bg_color
    @custom_class = custom_class
  end
end
