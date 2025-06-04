# frozen_string_literal: true

module BoundariesHelper
  def po_value(po_val, counter)
    if counter.blank?
      po_val
    else
      return po_val unless po_val == counter

      0
    end
  end
end
