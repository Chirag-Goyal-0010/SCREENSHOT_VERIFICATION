# This file is copied to spec/ when you run 'rails generate rspec:install'

require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
require 'sidekiq/testing'
require 'database_cleaner-active_record'

Dir[Rails.root.join('spec/support/**/*.rb')].sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

# ----------------------------
# RSpec Configuration
# ----------------------------
RSpec.configure do |config|
  # Fixtures path
  config.fixture_path = "#{::Rails.root}/spec/fixtures" if config.respond_to?(:fixture_path=)

  # Use transactional fixtures
  config.use_transactional_fixtures = true

  # Automatically mix in different behaviours to your tests based on file location
  config.infer_spec_type_from_file_location!

  # Filter Rails gems from backtrace
  config.filter_rails_from_backtrace!

  # FactoryBot syntax
  config.include FactoryBot::Syntax::Methods

  # Sidekiq inline jobs for tests
  Sidekiq::Testing.inline!

  # DatabaseCleaner setup
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  # Ensure ActiveJob runs in test mode
  config.before(:each) do
    ActiveJob::Base.queue_adapter = :test
  end
end
