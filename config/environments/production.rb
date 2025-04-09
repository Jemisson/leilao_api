require "active_support/core_ext/integer/time"

Rails.application.configure do
  Rails.application.routes.default_url_options[:host] = 'https://apileilao.codenova.com.br/'
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.active_storage.service = :production
  config.action_cable.mount_path = '/cable'
  config.action_cable.url = 'wss://apileilao.codenova.com.br/cable'
  config.action_cable.allowed_request_origins = [
    'https://apileilao.codenova.com.br',
    'https://leilao.codenova.com.br'
  ]
  config.force_ssl = true

  config.log_formatter = ::Logger::Formatter.new

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  else
    log_path = "/home/deploy/leilao_api/shared/log/production.log"
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
  config.action_cable.disable_request_forgery_protection = true

end
