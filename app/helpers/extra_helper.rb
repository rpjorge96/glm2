# frozen_string_literal: true

module ExtraHelper
  def extrable_url(extra)
    if extra.extrable.present?
      case extra.extrable
      when ControlUnitSubType
        control_unit_sub_type_url(extra.extrable)
      when ControlUnitSubTypeProject
        control_unit_sub_type_project_url(extra.extrable)
      else
        raise "Unknown extrable type"
      end
    else
      extras_url
    end
  end
end
