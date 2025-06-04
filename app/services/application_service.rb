# frozen_string_literal: true

class ApplicationService
  include Rails.application.routes.url_helpers
  Result = Struct.new(:success?, :data, :error, keyword_init: true)

  def self.call(...)
    new(...).call
  end
end
