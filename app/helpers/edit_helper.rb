# frozen_string_literal: true

module EditHelper
  def section_class
    "bg-gray-50 dark:bg-gray-900 p-3 sm:p-5"
  end

  def div_edit_class
    "py-8 px-4 mx-auto lg:py-2"
  end

  def h1_edit_class
    "mb-4 text-xl font-bold text-gray-900 dark:text-white"
  end

  def div_links_edit_class
    "flex items-center justify-start space-x-4 mt-6"
  end

  def link_edit_class
    "text-primary-700 hover:text-primary-900 dark:text-primary-500 dark:hover:text-primary-700"
  end
end
