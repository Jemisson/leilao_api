require "active_support/core_ext/integer/time"

Rails.application.configure do
  Rails.application.routes.default_url_options[:host] = 'https://api.leiloescapuci.com.br/'
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.active_storage.service = :production
  config.force_ssl = true

  config.log_formatter = ::Logger::Formatter.new

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  else
    log_path = Rails.root.join('log/production.log')
    logger = ActiveSupport::Logger.new(log_path, 'daily')
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  config.log_tags = [:request_id]
  config.log_level = :debug
  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false
  config.active_record.dump_schema_after_migration = false
end
