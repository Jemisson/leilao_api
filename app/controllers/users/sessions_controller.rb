# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    token = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first

    render json: {
      message: 'Login realizado com sucesso',
      user: {
        id: resource.id,
        email: resource.email,
        jti: resource.jti
      },
      token: token
    }, status: :ok
  end

  def respond_to_on_destroy
    if current_user
      render json: { message: 'Logout realizado com sucesso' }, status: :ok
    else
      render json: { error: 'Falha no logout' }, status: :unauthorized
    end
  end
end
