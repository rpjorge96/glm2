# <%= render(TextFieldComponent.new(max_characters: 400, form: form, rows: 6, field: :field))%>
# where
# max_characters: integer,  is the amount of characters it allows to be inputted before alerting
# form: form, is default as the component is meant to be used in a form partial
# rows: integer, is the amount of rows for the text area
# field: :field, is the name of the form field

class TextFieldComponent < ViewComponent::Base
  attr_accessor :form
  include ApplicationHelper
  def initialize(max_characters:, rows:, form:, field:)
    @max_characters = max_characters
    @form = form
    @rows = rows
    @field = field
  end
end
