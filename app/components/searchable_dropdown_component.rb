# frozen_string_literal: true

class SearchableDropdownComponent < ViewComponent::Base
  include ApplicationHelper
  def initialize(form:, field:, hidden_field:, items: {}, config: {})
    @form = form
    @field = field
    @hidden_field = hidden_field
    @items = items
    @config = config
  end

  def keys
    @items[:keys]
  end

  def values
    @items[:values]
  end

  def label
    @config[:label]
  end

  def display_column
    @config[:display_column]
  end

  def placeholder
    @config[:placeholder] || ""
  end

  def is_required
    @config[:is_required] || false
  end

  def allow_new_value
    @config[:allow_new_value] || false
  end

  def custom_css
    @config[:custom_css] || "w-full"
  end
end
