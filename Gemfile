source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.6'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 7.0.8', '>= 7.0.8.7'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.4'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 5.0'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bcrypt', '~> 3.1.7'
gem 'bootsnap', require: false

# Add gems no longer part of Ruby's standard library
gem 'bigdecimal' # Ensure BigDecimal is available
gem 'drb' # Distributed Ruby, required by ActiveSupport
gem 'mutex_m' # Mutex library needed for ActiveSupport
gem 'stringio', '3.1.1' # Required by other libraries

# RuboCop Gems for Linting
gem 'rubocop', require: false
gem 'rubocop-factory_bot', require: false
gem 'rubocop-rails', require: false
gem 'rubocop-rspec', require: false

# Uncomment if you need Sass for CSS processing
# gem "sassc-rails"

# Uncomment if you need Active Storage variants for image processing
# gem "image_processing", "~> 1.2"

group :development, :test do
  # Debugging tools
  gem 'debug', platforms: %i[mri mingw x64_mingw]

  # RSpec for testing
  gem 'rspec-rails', '~> 5.0' # RSpec 6.0 is available if you're using Rails 7+
end

group :development do
  # Console on exception pages
  gem 'web-console'

  # Uncomment to add speed badges during development
  # gem "rack-mini-profiler"

  # Uncomment for faster commands on slow machines
  # gem "spring"
end

group :test do
  # FactoryBot for test data
  gem 'factory_bot_rails'

  # Faker for generating test data
  gem 'faker', '~> 2.20'

  # Shoulda Matchers for concise model and controller tests
  gem 'shoulda-matchers', '~> 5.0'

  # SimpleCov for test coverage reporting
  gem 'simplecov', require: false
end
