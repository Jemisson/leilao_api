# cable_server.rb
require_relative 'config/environment'
Rails.application.eager_load!
Rails.application.config.force_ssl = false
run ActionCable.server
# This file is used to start the ActionCable server in a standalone mode.
