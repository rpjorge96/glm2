# frozen_string_literal: true

class SellsSidebarComponent < ViewComponent::Base
  def initialize(user:)
    @user = user
  end

  def admin?
    @user.role.name == "Admin"
  end

  def sells?
    @user.role.name.downcase == "ventas"
  end
end
