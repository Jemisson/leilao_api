class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    token = Warden::JWTAuth::UserEncoder.new.call(resource, :user, nil).first

    render json: {
      message: 'Login realizado com sucesso',
      user: {
        id: resource.id,
        profile_id: resource.profile_user&.id,
        name: resource.profile_user&.name,
        email: resource.email,
        role: resource.role,
        created_at: resource.created_at
      },
      token: token
    }, status: :ok
  end

  def respond_to_on_destroy
    if current_user
      render json: { message: 'Logout realizado com sucesso' }, status: :ok
    else
      render json: { error: 'Falha no logout!' }, status: :unauthorized
    end
  end
end
