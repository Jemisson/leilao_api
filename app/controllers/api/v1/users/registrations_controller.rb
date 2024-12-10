# frozen_string_literal: true

module Api
  module V1
    module Users
      class RegistrationsController < Devise::RegistrationsController
        respond_to :json

        private

        def respond_with(resource, _opts = {})
          if resource.persisted?
            render json: { message: 'Cadastro realizado com sucesso', user: resource }, status: :created
          else
            render json: { message: 'Erro ao realizar cadastro', errors: resource.errors.full_messages },
                   status: :unprocessable_entity
          end
        end
      end
    end
  end
end