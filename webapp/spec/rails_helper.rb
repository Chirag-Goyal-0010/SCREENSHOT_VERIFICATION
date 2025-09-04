# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
require 'sidekiq/testing'
require 'capybara/rspec'

# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

# Ensure the test database schema matches the current schema
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  # Fixtures
  config.fixture_paths = [Rails.root.join('spec/fixtures')]

  # Run each example inside a transaction
  config.use_transactional_fixtures = true

  # Infer spec type from file location (so /models → type: :model etc.)
  config.infer_spec_type_from_file_location!

  # Filter Rails gems in backtraces
  config.filter_rails_from_backtrace!

  # -----------------------------
  # ✅ Custom project-specific setup
  # -----------------------------

  # FactoryBot helpers
  config.include FactoryBot::Syntax::Methods

  # Sidekiq runs jobs inline for testing
  Sidekiq::Testing.inline!

  # Clean database between tests
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
  
  config.before(:each) do
    ActiveJob::Base.queue_adapter = :test
  end
end
