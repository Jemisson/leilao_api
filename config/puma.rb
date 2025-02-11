# Este arquivo de configuração será avaliado pelo Puma. Os métodos de nível superior
# invocados aqui fazem parte da DSL de configuração do Puma. Para mais informações
# sobre os métodos fornecidos pela DSL, consulte https://puma.io/puma/Puma/DSL.html.

# O Puma pode atender cada requisição em uma thread de um pool de threads interno.
# O método `threads` recebe dois números: mínimo e máximo.
# Qualquer biblioteca que use pools de threads deve ser configurada para corresponder
# ao valor máximo especificado para o Puma. O padrão é 5 threads para mínimo e máximo.
max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

# Ambiente do Rails
rails_env = ENV.fetch("RAILS_ENV") { "development" }

# Configurações específicas para produção
if rails_env == "production"
  # Número de workers (processos). Deve ser igual ao número de núcleos de CPU.
  # Defina a variável de ambiente `WEB_CONCURRENCY` para ajustar o número de workers.
  worker_count = Integer(ENV.fetch("WEB_CONCURRENCY") { Concurrent.physical_processor_count })
  workers worker_count

  # Pré-carrega a aplicação para reduzir o uso de memória e melhorar a performance.
  preload_app!

  # Configuração do fork de workers para compatibilidade com o Action Cable (WebSocket)
  before_fork do
    ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
    ActionCable.server.stop if defined?(ActionCable)
  end

  on_worker_boot do
    ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
    ActionCable.server.restart if defined?(ActionCable)
  end
end

# Timeout para workers em ambientes de desenvolvimento
worker_timeout 3600 if rails_env == "development"

# Porta que o Puma irá escutar (padrão: 3000)
port ENV.fetch("PORT") { 4000 }

# Ambiente do Puma
environment rails_env

# Arquivo PID para armazenar o ID do processo do Puma
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# Permite que o Puma seja reiniciado pelo comando `bin/rails restart`
plugin :tmp_restart

# Configuração do bind para aceitar conexões externas (útil para Docker ou servidores remotos)
bind "tcp://0.0.0.0:#{ENV.fetch("PORT") { 4000 }}"

# Configuração do log (opcional)
if rails_env == "production"
  stdout_redirect "log/puma.stdout.log", "log/puma.stderr.log", true
end

# Configuração de threads para o Action Cable
if defined?(ActionCable)
  after_fork do
    ActionCable.server.config.worker_pool_size = max_threads_count
  end
end
