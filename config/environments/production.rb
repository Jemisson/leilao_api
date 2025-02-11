require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Configuração do host para URLs gerados pelo Rails (ex: ActionMailer)
  Rails.application.routes.default_url_options[:host] = 'https://api_leilao.codenova.com.br'

  # Configurações específicas para o ambiente de produção
  # Código não é recarregado entre requisições
  config.enable_reloading = false

  # Eager load carrega todo o código da aplicação na memória, melhorando a performance
  config.eager_load = true

  # Desabilita relatórios de erros detalhados e ativa o cache
  config.consider_all_requests_local = false

  # Exige a chave mestra para descriptografar credenciais
  config.require_master_key = true

  # Desabilita o servidor de arquivos estáticos (deixe o Nginx/Apache cuidar disso)
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Configuração do host de assets (se estiver usando um CDN ou servidor de assets)
  # config.asset_host = "https://assets.seu-dominio.com"

  # Configuração para envio de arquivos via Nginx
  config.action_dispatch.x_sendfile_header = "X-Accel-Redirect"

  # Configuração do Active Storage para armazenamento local
  config.active_storage.service = :local

  # Configuração do Action Cable (WebSocket)
  config.action_cable.url = "wss://api_leilao.codenova.com.br/cable"
  config.action_cable.allowed_request_origins = ['https://api_leilao.codenova.com.br']

  # Força o uso de SSL e configura Strict-Transport-Security
  config.force_ssl = true

  # Configuração de logs para STDOUT (útil para integração com sistemas de log como Docker)
  config.logger = ActiveSupport::Logger.new(STDOUT)
    .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
    .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  # Adiciona tags aos logs (útil para rastreamento de requisições)
  config.log_tags = [:request_id]

  # Define o nível de log (info é o padrão para produção)
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Configuração de cache (use memcached ou Redis em produção)
  config.cache_store = :memory_store

  # Configuração de filas para Active Job (use Sidekiq, Resque, etc.)
  # config.active_job.queue_adapter = :sidekiq
  # config.active_job.queue_name_prefix = "nome_do_app_production"

  # Configuração do Action Mailer
  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              'smtp.seu-servidor.com',
    port:                 587,
    user_name:            ENV['SMTP_USERNAME'],
    password:             ENV['SMTP_PASSWORD'],
    authentication:       'plain',
    enable_starttls_auto: true
  }

  # Configuração de fallbacks para I18n
  config.i18n.fallbacks = true

  # Desabilita logs de depreciação
  config.active_support.report_deprecations = false

  # Não despeja o schema após migrações
  config.active_record.dump_schema_after_migration = false

  # Proteção contra DNS rebinding e ataques ao cabeçalho Host
  config.hosts = [
    "api_leilao.codenova.com.br", # Permite requisições do domínio principal
    /.*\.api_leilao.codenova\.com/ # Permite requisições de subdomínios
  ]

  # Exclui o endpoint de health check da proteção de host
  config.host_authorization = { exclude: ->(request) { request.path == "/up" } }

  # Configuração de compressão de assets
  config.middleware.use Rack::Deflater

  # Configuração de tempo de compilação de assets
  config.assets.compile = false
  config.assets.digest = true
  config.assets.version = '1.0'

  # Configuração de segurança adicional
  config.action_dispatch.default_headers = {
    'X-Frame-Options' => 'DENY',
    'X-Content-Type-Options' => 'nosniff',
    'X-XSS-Protection' => '1; mode=block',
    'Strict-Transport-Security' => 'max-age=31536000; includeSubDomains; preload'
  }
end
