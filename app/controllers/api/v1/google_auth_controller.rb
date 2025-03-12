class Api::V1::GoogleAuthController < ApplicationController
  def authenticate
    google_auth_params = params[:google_auth] || params

    token = google_auth_params[:token]
    email = google_auth_params[:email]

    user_data = fetch_google_user_data(token)

    return render json: { error: 'Token inválido' }, status: :unauthorized unless user_data

    user = User.find_or_initialize_by(email: email)
    if user.new_record?
      return render json: {
        message: 'Usuário não cadastrado',
        user: {
          name: user_data['name'],
          email: user_data['email'],
          role: nil
        }
      }, status: :ok
    end

    jwt_token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first

    render json: {
      message: 'Autenticado com sucesso!',
      token: jwt_token,
      user: {
        id: user.id,
        name: user.profile_user&.name,
        email: user.email,
        role: user.role
      }
    }, status: :ok
  end

  private

  def fetch_google_user_data(token)
    url = "https://www.googleapis.com/oauth2/v3/userinfo?access_token=#{token}"
    response = HTTParty.get(url)

    return nil unless response.success?

    JSON.parse(response.body)
  end
end
