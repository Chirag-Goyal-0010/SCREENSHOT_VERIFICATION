require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is eager loaded on boot for better performance.
  config.eager_load = true

  # Full error reports are disabled in production.
  config.consider_all_requests_local = false

  # Enable caching for performance.
  config.action_controller.perform_caching = true
  config.cache_store = :memory_store

  # Serve static files if ENV['RAILS_SERVE_STATIC_FILES'] is set (Railway sets this automatically)
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=#{1.year.to_i}"
  }

  # Store uploaded files on the local file system (for dev) or S3 (for production)
  config.active_storage.service = :local # change to :amazon if using S3

  # Force all access to the app over SSL.
  config.force_ssl = true

  # Logging
  config.log_level = :info
  config.log_tags = [:request_id]
  config.logger = ActiveSupport::TaggedLogging.new(Logger.new(STDOUT))

  # Internationalization fallbacks
  config.i18n.fallbacks = true

  # Do not dump schema after migrations
  config.active_record.dump_schema_after_migration = false

  # Puma thread pool defaults (optional, for Railway)
  config.threadsafe! if Rails.version < "5" # ignore if Rails 6+
end
