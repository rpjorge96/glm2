# frozen_string_literal: true

class Pdf::HeaderComponent < ViewComponent::Base
  def initialize(quotation:)
    @quotation = quotation
  end
end
