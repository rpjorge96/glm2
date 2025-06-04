# frozen_string_literal: true

class Pdf::HeaderDataComponent < ViewComponent::Base
  def initialize(quotation:, page:, financial_entity_id:, bg_color: nil)
    @quotation = quotation
    @page = page
    @total_pages = quotation.calculate_total_pages(financial_entity_id)
    @bg_color = bg_color
  end
end
