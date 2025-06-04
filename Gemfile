# frozen_string_literal: true

source "https://rubygems.org"

ruby "~> 3.3.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.2"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
gem "redis", ">= 4.0.1"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

gem "cssbundling-rails", "~> 1.3"

gem "devise", "~> 4.9"
gem "devise_invitable", "~> 2.0.0"

gem "discard", "~> 1.3"
gem "pagy"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

gem "cancancan", "~> 3.5"
gem "google-cloud-storage", "~> 1.11", require: false
gem "roo", "~> 2.10.0"

gem "paper_trail"

gem "caxlsx"
gem "caxlsx_rails"

gem "newrelic_rpm"

gem "sidekiq", "~> 7.2"
gem "sidekiq-status"

gem "rollbar"

gem "wicked_pdf"
gem "wkhtmltopdf-binary", ">= 0.12.6.7", "< 0.13.0", ">= 0.12.6.7", "< 0.13.0", group: :development
gem "wkhtmltopdf-heroku", group: :production

gem "tailwindcss-rails", "~> 2.3"

gem "city-state"
gem "countries", "~> 6.0", require: "countries/global"

gem "ransack", "~> 4.1"

gem "prawn", "~> 2.5"
gem "prawn-table", "~> 0.2.2"

gem "money-rails", "~> 1.15"

gem "recaptcha"

gem "standard"

gem "rubocop-rails", require: false

gem "grover"
gem "view_component"

gem "sendgrid-ruby"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "byebug"
  gem "debug", platforms: %i[mri windows]
  gem "dotenv-rails"
  gem "rspec-rails", "~> 6.0.0"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem "annotate", "~> 3.2"
  gem "better_errors"
  gem "binding_of_caller"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"

  gem "database_cleaner"
  # gem 'pundit-matchers', '~> 3.1'
  gem "shoulda-callback-matchers"
  gem "shoulda-matchers"
  gem "simplecov"
  gem "timecop"
end
