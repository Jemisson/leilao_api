# frozen_string_literal: true

require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'

# Configurações básicas
set :application_name, 'leilao_api'
set :domain, '108.181.224.45'
set :deploy_to, '/home/production/leilao_api'
set :repository, 'git@github.com:Jemisson/leilao_api.git'
set :branch, 'production'
set :user, 'production'
set :port, '22'
set :forward_agent, true
set :rails_env, 'production'

# Configuração do RVM
task :remote_environment do
  invoke :'rvm:use[ruby-3.0.0]'
end

# Tarefa de setup (cria diretórios e arquivos necessários)
task setup: :remote_environment do
  queue! %(mkdir -p "#{deploy_to}/shared/log")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/shared/log")

  queue! %(mkdir -p "#{deploy_to}/shared/config")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/shared/config")

  queue! %(mkdir -p "#{deploy_to}/shared/pids")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/shared/pids")

  queue! %(mkdir -p "#{deploy_to}/shared/tmp")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/shared/tmp")

  queue! %(touch "#{deploy_to}/shared/config/database.yml")
  queue  %(echo "-----> Be sure to edit 'shared/config/database.yml'.")

  queue! %(touch "#{deploy_to}/shared/config/application.yml")
  queue  %(echo "-----> Be sure to edit 'shared/config/application.yml'.")

  queue! %(touch "#{deploy_to}/shared/config/secrets.yml")
  queue  %(echo "-----> Be sure to edit 'shared/config/secrets.yml'.")
end

# Tarefa principal de deploy
desc 'Deploys the current version to the server.'
task deploy: :remote_environment do
  invoke :'check_env' # Verifica variáveis de ambiente
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'deploy:cleanup'

    to :launch do
      queue %(echo -n '-----> Creating new restart.txt: ')
      queue "touch #{deploy_to}/shared/tmp/restart.txt"
      invoke :'restart_puma' # Reinicia o Puma
      invoke :'restart_action_cable' # Reinicia o Action Cable
    end
  end
end

# Tarefa para reiniciar o Puma
desc 'Restart Puma'
task :restart_puma do
  queue! %(echo "-----> Restarting Puma")
  queue! %(sudo systemctl restart puma)
end

# Tarefa para reiniciar o Action Cable
desc 'Restart Action Cable'
task :restart_action_cable do
  queue! %(echo "-----> Restarting Action Cable")
  queue! %(sudo systemctl restart action_cable)
end

# Tarefa para verificar variáveis de ambiente
desc 'Check environment variables'
task :check_env do
  queue! %(echo "-----> Checking environment variables")
  queue! %(echo "RAILS_MASTER_KEY: #{ENV['RAILS_MASTER_KEY']}")
  queue! %(echo "DATABASE_URL: #{ENV['DATABASE_URL']}")
  queue! %(echo "REDIS_URL: #{ENV['REDIS_URL']}")
end

# Configurações para o ambiente de produção
task :production do
  set :rails_env, 'production'
  set :user, 'production'
  set :domain, '108.181.224.45'
  set :deploy_to, '/home/production/leilao_api'
  set :branch, 'production'
end

# Configurações para o ambiente de staging
task :staging do
  set :rails_env, 'staging'
  set :user, 'development'
  set :domain, '108.181.224.45'
  set :deploy_to, '/home/development/leilao_api'
  set :branch, 'main'
end

# Fix para term mode
set :term_mode, nil

# Caminhos compartilhados
set :shared_paths, ['config/database.yml', 'log', 'tmp', 'config/application.yml', 'config/secrets.yml']

# Tarefas para visualização de logs
desc 'Show Rails logs.'
task 'logs:rails': :remote_environment do
  queue 'echo "Contents of the log file are as follows:"'
  queue "tail -f #{deploy_to}/shared/log/production.log"
end

desc 'Show Nginx logs.'
task 'logs:nginx': :remote_environment do
  queue 'echo "Contents of the log file are as follows:"'
  queue 'tail -f /opt/nginx/logs/error.log'
end

desc 'Show Action Cable logs.'
task 'logs:cable': :remote_environment do
  queue 'echo "Contents of the Action Cable log file are as follows:"'
  queue "tail -f #{deploy_to}/shared/log/cable.log"
end

# Tarefa de rollback
desc 'Rolls back the latest release'
task rollback: :remote_environment do
  queue! %(echo "-----> Rolling back to previous release for instance: #{domain}")

  # Cria um novo symlink para o release anterior
  queue %(echo -n "-----> Creating new symlink from the previous release: ")
  queue %(ls "#{deploy_to}/releases" -Art | sort | tail -n 2 | head -n 1)
  queue! %(ls -Art "#{deploy_to}/releases" | sort | tail -n 2 | head -n 1 | xargs -I active ln -nfs "#{deploy_to}/releases/active" "#{deploy_to}/current")

  # Remove o release mais recente
  queue %(echo -n "-----> Deleting active release: ")
  queue %(ls "#{deploy_to}/releases" -Art | sort | tail -n 1)
  queue! %(ls "#{deploy_to}/releases" -Art | sort | tail -n 1 | xargs -I active rm -rf "#{deploy_to}/releases/active")

  queue %(echo -n "-----> Creating new restart.txt: ")
  queue "touch #{deploy_to}/shared/tmp/restart.txt"
end

# Tarefas de manutenção (usando a gem Turnout)
desc 'TurnOff'
task 'system:turnoff': :remote_environment do
  queue %(echo -n "-----> Turn Off System: ")
  queue! %(cd "#{deploy_to}/current")
  queue "RAILS_ENV=#{rails_env} bundle exec rake maintenance:start"
end

desc 'TurnOn'
task 'system:turnon': :remote_environment do
  queue %(echo -n "-----> Turn On System: ")
  queue! %(cd "#{deploy_to}/current")
  queue "RAILS_ENV=#{rails_env} bundle exec rake maintenance:end"
end
