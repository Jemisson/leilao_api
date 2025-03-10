class Api::V1::GoogleAuthController < ApplicationController
  def authenticate
    token = params[:token]
    email = params[:email]

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

    jwt_token = user.generate_jwt

    render json: {
      message: 'Autenticado com sucesso!',
      token: jwt_token
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
