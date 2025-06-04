# frozen_string_literal: true

module QueryParams
  def pagy_paginate_relation(relation)
    pagy, records = pagy(relation, page: @page, items: @per_page)
    [pagy, records]
  end

  def sort_by_relation(relation)
    sort_by = @sort_by
    return relation.order(created_at: :desc) if sort_by.blank?

    # if field has a '-' at the beginning, it means that it should be ordered in descending order
    if sort_by.start_with?("-")
      field = sort_by[1..]
      relation.order("#{field} DESC")
    else
      relation.order(sort_by)
    end
  end

  def process_query_params(relation)
    relation = sort_by_relation(relation)
    pagy_paginate_relation(relation)
  end
end
