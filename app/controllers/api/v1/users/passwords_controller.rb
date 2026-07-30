# frozen_string_literal: true

module Api
  module V1
    module Users
      class PasswordsController < ApplicationController
        before_action :authenticate_user!

        def update
          if current_user.update_with_password(password_params)
            bypass_sign_in(current_user)
            render json: { message: 'Senha alterada com sucesso!' }, status: :ok
          else
            render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
          end
        end

        private

        def password_params
          params.require(:user).permit(:current_password, :password, :password_confirmation)
        end
      end
    end
  end
end
