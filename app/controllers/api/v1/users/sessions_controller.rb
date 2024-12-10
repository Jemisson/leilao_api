# frozen_string_literal: true

module Api
  module V1
    module Users
      class SessionsController < Devise::SessionsController
        respond_to :json

        private

        def respond_with(resource, _opts = {})
          render json: { message: 'Login realizado com sucesso', user: resource }, status: :ok
        end

        def respond_to_on_destroy
          if current_user
            render json: { message: 'Logout realizado com sucesso' }, status: :ok
          else
            render json: { message: 'Falha no logout' }, status: :unauthorized
          end
        end
      end
    end
  end
end
