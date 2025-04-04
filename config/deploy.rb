# frozen_string_literal: true

require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm'

# set :rvm_path, '/usr/james/.rvm/scripts/rvm'
# set :ruby_version, '3.0.0'

# Repository project
set :application_name, 'leilao_api'
set :domain, '108.181.224.45'
set :deploy_to, '/home/production/leilao_api'
set :repository, 'git@github.com:Jemisson/leilao_api.git'
set :branch, 'production'
set :user, 'production'
set :port, '22'
set :forward_agent, true
set :rails_env, 'production'

task :remote_environment do
  invoke :'rvm:use[ruby-3.0.0]'
end

task setup: :remote_environment do
  queue! %(mkdir -p "#{deploy_to}/shared/log")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/shared/log")

  queue! %(mkdir -p "#{deploy_to}/storage")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/storage")
  queue! %(touch "#{deploy_to}/storage/index.html")

  queue! %(mkdir -p "#{deploy_to}/shared/config")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/shared/config")

  queue! %(mkdir -p "#{deploy_to}/shared/pids")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/shared/pids")

  queue! %(mkdir -p "#{deploy_to}/shared/tmp/pids")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/shared/tmp/pids")

  queue! %(mkdir -p "#{deploy_to}/shared/tmp")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/shared/tmp")

  queue! %(touch "#{deploy_to}/shared/config/database.yml")
  queue  %(echo "-----> Be sure to edit 'shared/config/database.yml'.")

  queue! %(touch "#{deploy_to}/shared/config/application.yml")
  queue  %(echo "-----> Be sure to edit 'shared/config/application.yml'.")

  queue! %(touch "#{deploy_to}/shared/config/secrets.yml")
  queue  %(echo "-----> Be sure to edit 'shared/config/secrets.yml'.")

  queue! %(touch "#{deploy_to}/shared/log/cable.log")
  queue! %(chmod g+rx,u+rw "#{deploy_to}/shared/log/cable.log")
end

desc 'Deploys the current version to the server.'
task deploy: :remote_environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'deploy:cleanup'

    to :launch do
      queue %(echo -n '-----> Creating new restart.txt: ')
      queue "touch #{deploy_to}/shared/tmp/restart.txt"

      invoke :'action_cable:restart'
    end
  end
end

# Server Production
task :production do
  set :rails_env, 'production'
  set :user, 'production'
  set :domain, '108.181.224.45'
  set :deploy_to, '/home/production/leilao_api'
  set :branch, 'production'

  set :cable_pid, "#{deploy_to}/shared/tmp/pids/cable.pid"
  set :cable_log, "#{deploy_to}/shared/log/cable.log"
end

# Server staging
task :staging do
  set :rails_env, 'production'
  set :user, 'deploy'
  set :domain, '108.181.224.196'
  set :deploy_to, '/home/deploy/leilao_api'
  set :branch, 'production'

  set :cable_pid, "#{deploy_to}/shared/tmp/pids/cable.pid"
  set :cable_log, "#{deploy_to}/shared/log/cable.log"
end

desc 'Start Action Cable'
task 'action_cable:start': :remote_environment do
  queue! %(echo "-----> Starting Action Cable...")
  queue! %(mkdir -p #{deploy_to}/shared/tmp/pids)
  queue! %(cd #{deploy_to}/current && RACKUP=cable_server.rb RAILS_ENV=#{rails_env} nohup bundle exec puma -p 3002 -e #{rails_env} --pidfile #{cable_pid} > #{cable_log} 2>&1 &)
end

desc 'Stop Action Cable'
task 'action_cable:stop': :remote_environment do
  queue! %(echo "-----> Stopping Action Cable...")
  queue! %(
    if [ -f #{cable_pid} ]; then
      kill -TERM $(cat #{cable_pid}) && rm #{cable_pid};
    else
      echo "Cable PID file not found. Skipping stop.";
    fi
  )
end

desc 'Restart Action Cable'
task 'action_cable:restart': :remote_environment do
  invoke :'action_cable:stop'
  invoke :'action_cable:start'
end

# Server preview
# task :preview do
#   set :rails_env, 'preview'
#   set :user, 'development'
#   set :domain, '108.181.224.45'
#   set :deploy_to, '/home/development/clinica_de_olhos_api'
#   set :branch, 'staging'
# end

# Fix
set :term_mode, nil

set :shared_paths, [
  'public/uploads',
  'config/database.yml',
  'log',
  'tmp',
  'config/application.yml',
  'config/secrets.yml'
]

# Show logs
desc 'Show logs rails.'
task 'logs:rails': :remote_environment do
  queue 'echo "Contents of the log file are as follows:"'
  queue "tail -f #{deploy_to}/shared/log/production.log"
end

desc 'Show logs Nginx.'
task 'logs:nginx': :remote_environment do
  queue 'echo "Contents of the log file are as follows:"'
  queue 'tail -f /opt/nginx/logs/error.log'
end

# Roolback
desc 'Rolls back the latest release'
task rollback: :remote_environment do
  queue! %(echo "-----> Rolling back to previous release for instance: #{domain}")

  # Delete existing sym link and create a new symlink pointing to the previous release
  queue %(echo -n "-----> Creating new symlink from the previous release: ")
  queue %(ls "#{deploy_to}/releases" -Art | sort | tail -n 2 | head -n 1)
  queue! %(ls -Art "#{deploy_to}/releases" | sort | tail -n 2 | head -n 1 | xargs -I active ln -nfs "#{deploy_to}/releases/active" "#{deploy_to}/current")

  # Remove latest release folder (active release)
  queue %(echo -n "-----> Deleting active release: ")
  queue %(ls "#{deploy_to}/releases" -Art | sort | tail -n 1)
  queue! %(ls "#{deploy_to}/releases" -Art | sort | tail -n 1 | xargs -I active rm -rf "#{deploy_to}/releases/active")

  queue %(echo -n "-----> Creating new restart.txt: ")
  queue "touch #{deploy_to}/shared/tmp/restart.txt"
end

# Maintenance
# TornOff (Necessary gem https://github.com/biola/turnout)
desc 'TurnOff'
task 'system:turnoff': :remote_environment do
  queue %(echo -n "-----> Turn Off System: ")
  queue! %(cd "#{deploy_to}/current")
  queue "RAILS_ENV=#{rails_env} bundle exec rake maintenance:start"
end

desc 'TurnOn'
task 'system:turnon': :remote_environment do
  queue %(echo -n "-----> Turn Off System: ")
  queue! %(cd "#{deploy_to}/current")
  queue "RAILS_ENV=#{rails_env} bundle exec rake maintenance:end"
end
