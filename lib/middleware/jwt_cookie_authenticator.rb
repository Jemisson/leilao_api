# frozen_string_literal: true

class JWTCookieAuthenticator
  def initialize(app)
    @app = app
  end

  def call(env)
    if env['HTTP_AUTHORIZATION'].blank? && env['rack.request.cookie_hash']&.dig('jwt')
      env['HTTP_AUTHORIZATION'] = "Bearer #{env['rack.request.cookie_hash']['jwt']}"
    end
    @app.call(env)
  end
end
