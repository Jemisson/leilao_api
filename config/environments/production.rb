require "active_support/core_ext/integer/time"

Rails.application.configure do
  Rails.application.routes.default_url_options[:host] = 'https://api_leilao.codenova.com.br/'
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
  config.logger = ActiveSupport::Logger.new(STDOUT)
                                       .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
                                       .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  config.log_tags = [ :request_id ]
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true
  config.active_support.report_deprecations = false
  config.active_record.dump_schema_after_migration = false
end
