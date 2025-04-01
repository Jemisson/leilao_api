# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    build_resource(sign_up_params)

    # Se os parâmetros de profile foram enviados, cria o perfil associado
    resource.build_profile_user(profile_user_params) if params[:profile_user].present?

    resource.save!
    yield resource if block_given?

    if resource.persisted?
      if resource.active_for_authentication?
        sign_up(resource_name, resource)
        render json: resource, status: :created
      else
        expire_data_after_sign_in!
        render json: { message: 'Usuário cadastrado, mas inativo.' }, status: :created
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      render json: resource.errors, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def profile_user_params
    params.require(:profile_user).permit(
      :name, :cpf, :birth, :street, :number, :neighborhood, :city,
      :state, :country, :zip_code, :phone
    )
  end
end
