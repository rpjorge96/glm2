# frozen_string_literal: true

class Pdf::ExtraComponent < ViewComponent::Base
  def initialize(data:)
    @data = data
  end
end
