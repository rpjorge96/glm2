# frozen_string_literal: true

module TableHelper
  def div_table_class
    "relative shadow-md sm:rounded-lg"
  end

  def table_class
    "table-auto w-full text-sm text-left text-gray-500 dark:text-gray-400"
  end

  def inner_table_class
    "table-auto text-sm text-left text-gray-500 dark:text-gray-400 w-full"
  end

  def thead_class
    "text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400"
  end

  def tr_class
    "bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-100 dark:hover:bg-gray-600"
  end

  def tr_class_thicker
    "bg-white border-b-4 dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-100 dark:hover:bg-gray-600"
  end

  def th_td_class
    "px-4 py-3"
  end
end
