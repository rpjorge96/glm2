# frozen_string_literal: true

class AddOperationInitialDateToProjects < ActiveRecord::Migration[7.1]
  def change
    add_column :projects, :operation_initial_date, :date
  end
end
