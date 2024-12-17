# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  # Validação da autenticação para a rota /auth/check
  before_action :authenticate_user!, only: [:check]

  def check
    render json: {
      message: 'User is authenticated',
      user: {
        id: current_user.id,
        email: current_user.email
      }
    }, status: :ok
  end

  private

  # Resposta ao fazer login
  def respond_with(resource, _opts = {})
    token = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first

    # Define o cookie com o token JWT
    cookies.signed[:jwt] = {
      value: token,
      httponly: true, # Protege contra XSS
      secure: Rails.env.production?, # Apenas HTTPS em produção
      same_site: :lax
    }

    render json: {
      message: 'Login realizado com sucesso',
      user: {
        id: resource.id,
        email: resource.email
      }
    }, status: :ok
  end

  # Resposta ao fazer logout
  def respond_to_on_destroy
    cookies.delete(:jwt) # Deleta o cookie JWT
    render json: { message: 'Logout realizado com sucesso' }, status: :ok
  end
end
