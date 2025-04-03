# cable_server.rb
require_relative 'config/environment'
Rails.application.eager_load!
run ActionCable.server
# This file is used to start the ActionCable server in a standalone mode.
