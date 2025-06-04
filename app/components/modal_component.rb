# frozen_string_literal: true

class ModalComponent < ViewComponent::Base
  def initialize(title:, partial:, modal_id:, opened: false, locals: {})
    @title = title
    @partial = partial
    @modal_id = modal_id
    @opened = opened
    @locals = locals
  end
end
