require 'simplecov'
require 'capybara/rspec'
require 'spec_helper'

# Load SimpleCov for test coverage
SimpleCov.start 'rails' do
  add_filter '/bin/'
  add_filter '/db/'
  add_filter '/spec/'
  # Uncomment to enforce minimum coverage percentage
  # SimpleCov.minimum_coverage 90
end

SimpleCov.at_exit do
  SimpleCov.result.format!
  puts "Coverage is at #{SimpleCov.result.covered_percent.round(2)}%"
end

# Configure Capybara drivers
Capybara.default_driver = :rack_test # Fast, non-JS tests
Capybara.javascript_driver = :selenium_chrome # Use for JS-enabled tests

# Ensure the Rails environment is set to test
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort('The Rails environment is running in production mode!') if Rails.env.production?

# Require RSpec and Rails
require 'rspec/rails'

# Maintain test schema and handle pending migrations
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

# Configure RSpec
RSpec.configure do |config|
  # Configure system tests to use appropriate drivers
  config.before(:each, type: :system) do
    driven_by :rack_test # Use :selenium for JavaScript-enabled tests
  end

  config.include Rails.application.routes.url_helpers

  # Set the fixture path
  config.fixture_path = Rails.root.join('spec/fixtures').to_s

  # Use transactional fixtures for non-JS tests
  config.use_transactional_fixtures = true

  # Automatically infer spec types from file locations
  config.infer_spec_type_from_file_location!

  # Filter Rails gems from backtraces for clarity
  config.filter_rails_from_backtrace!

  # Configure Shoulda Matchers for RSpec and Rails
  Shoulda::Matchers.configure do |shoulda_config|
    shoulda_config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end
end
