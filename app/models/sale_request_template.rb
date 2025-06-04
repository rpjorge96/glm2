# == Schema Information
#
# Table name: sale_request_templates
#
#  id         :bigint           not null, primary key
#  body       :text
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class SaleRequestTemplate < ApplicationRecord
  has_and_belongs_to_many :projects
  attr_accessor :project_names

  validates :name, presence: true, allow_blank: false
  validates :body, presence: true, allow_blank: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[name]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[]
  end

  def formatted_body
    # Convert spaces to non-breaking spaces
    body_with_whitespace = body&.gsub(" ", "&nbsp;")

    # Convert newlines to <br> tags
    body_with_whitespace&.gsub("<p></p>", "<br>")
  end
end
