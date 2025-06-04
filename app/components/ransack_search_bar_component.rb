# frozen_string_literal: true

require "ransack/helpers/form_helper"
class RansackSearchBarComponent < ViewComponent::Base
  include Ransack::Helpers::FormHelper

  def initialize(q:, url:, field_name:, placeholder:)
    @q = q
    @url = url
    @field_name = field_name
    @placeholder = placeholder
  end
end
