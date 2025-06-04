# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @projects = Project.all
    @control_units = ControlUnit.all
    @chart_data = @projects.map { |project| project.control_units.count }
    @chart_categories = @projects.map(&:name)
  end
end
