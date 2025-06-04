# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  has_paper_trail

  def last_edited_by
    User.find(versions.last.whodunnit) if versions.last.whodunnit
  end

  def created_by
    User.find(versions.first.whodunnit)
  end

  # before_save :capitalize_first_letter_of_each_word_in_strings

  # private

  # EXCLUDED_ATTRIBUTES = %w[specific_field1 specific_field2].freeze
  # EXCLUDED_ATTRIBUTES = [].freeze

  # def capitalize_first_letter_of_each_word_in_strings
  #   attributes.each do |attr_name, attr_value|
  #     if !EXCLUDED_ATTRIBUTES.include?(attr_name) && self.class.columns_hash[attr_name].type == :string && attr_value.is_a?(String)
  #       self[attr_name] = attr_value.split.map { |word| word[0].upcase + word[1..] }.join(' ')
  #     end
  #   end
  # end
end
