# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User Authentication', type: :request do
  let(:user) { create(:user) }

  describe 'POST /login' do
    context 'com credenciais válidas' do
      it 'realiza o login e retorna o token do usuário' do
        post '/login', params: { user: { email: user.email, password: 'password123' } }

        expect(response).to have_http_status(:ok)

        json = response.parsed_body

        expect(json['message']).to eq('Login realizado com sucesso')
        expect(json['user']['email']).to eq(user.email)
      end
    end

    # context 'com credenciais inválidas' do
    #   it 'retorna um erro' do
    #     post '/login', params: { user: { email: user.email, password: 'wrongpassword' } }
    #     expect(response).to have_http_status(:unauthorized)

    #     json = response.parsed_body

    #     expect(json['error']).to eq('Invalid Email or password.')
    #   end
    # end
  end

  # describe 'POST /api/v1/signup' do
  #   context 'com parâmetros válidos' do
  #     it 'cria um novo usuário e retorna os dados' do
  #       post '/api/v1/signup', params: { user: { email: 'newuser@example.com', password: 'password', password_confirmation: 'password' } }
  #       expect(response).to have_http_status(:created)
  #       json = JSON.parse(response.body)
  #       expect(json['message']).to eq('Cadastro realizado com sucesso')
  #       expect(json['user']['email']).to eq('newuser@example.com')
  #     end
  #   end

  #   context 'com parâmetros inválidos' do
  #     it 'retorna um erro' do
  #       post '/api/v1/signup', params: { user: { email: '', password: 'password', password_confirmation: 'password' } }
  #       expect(response).to have_http_status(:unprocessable_entity)
  #       json = JSON.parse(response.body)
  #       expect(json['message']).to eq('Erro ao realizar cadastro')
  #     end
  #   end
  # end

  # describe 'DELETE /api/v1/logout' do
  #   context 'com um usuário logado' do
  #     it 'realiza o logout com sucesso' do
  #       sign_in user
  #       delete '/api/v1/logout'
  #       expect(response).to have_http_status(:ok)
  #       json = JSON.parse(response.body)
  #       expect(json['message']).to eq('Logout realizado com sucesso')
  #     end
  #   end

  #   context 'sem um usuário logado' do
  #     it 'retorna um erro de autorização' do
  #       delete '/api/v1/logout'
  #       expect(response).to have_http_status(:unauthorized)
  #       json = JSON.parse(response.body)
  #       expect(json['message']).to eq('Falha no logout')
  #     end
  #   end
  # end
end
