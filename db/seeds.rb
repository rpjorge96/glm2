# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Role.create!(name: "Admin", max_days_extend_quotation: 5, max_days_extend_reservation: 5, max_allowed_discount_percentage: 12 )
# User.create!( username: "user1", password: "password", role_id: 1)

puts "Running seed"

admin_role = Role.find_or_create_by(name: "Admin") do |role|
  role.max_days_extend_quotation = 15
  role.max_days_extend_reservation = 15
  role.max_allowed_discount_percentage = 12
end

otro_rol = Role.find_or_create_by(name: "otro rol") do |role|
  role.max_days_extend_quotation = 5
  role.max_days_extend_reservation = 5
  role.max_allowed_discount_percentage = 5
end

ventas_rol = Role.find_or_create_by(name: "Ventas") do |role|
  role.max_days_extend_quotation = 5
  role.max_days_extend_reservation = 5
  role.max_allowed_discount_percentage = 5
end

puts "Roles created"

User.find_or_create_by(username: "user1") do |user|
  user.password = "password"
  user.role_id = otro_rol.id
end

User.find_or_create_by(username: "Admin") do |user|
  user.password = "password"
  user.role_id = admin_role.id
end

User.find_or_create_by(username: "Vendedor") do |user|
  user.password = "password"
  user.role_id = ventas_rol.id
end

puts "Users created"

default_role = Role.find_by(name: "otro rol")
User.where(role: nil).find_each do |user|
  user.update!(role: default_role)
end

CountrySetting.create!(
  :códigos => ["GT"]
)

City.create!(
  country_code: "+502",
  state_code: "1301",
  name: "Guatemala City"
)

puts "countries and cities created"
