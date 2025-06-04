# frozen_string_literal: true

class DataTableComponent < ViewComponent::Base
  include TableHelper
  include Pagy::Frontend

  def initialize(headers:, rows:, sort_by:, page:, per_page:, pagy:, actions: nil, actions_partial: nil, table_body_partial: nil)
    @headers = headers
    @rows = rows
    @sort_by = sort_by
    @page = page
    @per_page = per_page
    @pagy = pagy
    @actions_partial = actions_partial
    @table_body_partial = table_body_partial
    @actions = actions
  end

  def sort_by_field
    return @sort_by[1..] if @sort_by&.start_with?("-")

    @sort_by
  end

  def actions_enabled
    @actions.present? || @actions_partial.present?
  end
end
