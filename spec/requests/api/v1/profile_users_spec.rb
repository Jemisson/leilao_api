# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ProfileUser API', type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) do
    token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
    { 'Authorization' => "Bearer #{token}" }
  end

  describe 'GET /api/v1/profile_users' do
    before do
      create_list(:profile_user, 3)
    end

    it 'retorna uma lista de perfis com metadados' do
      get '/api/v1/profile_users', headers: auth_headers
      expect(response).to have_http_status(:ok)

      json = response.parsed_body
      expect(json['data'].size).to eq(3)
      expect(json['meta']).to include(
        'total_count',
        'total_pages',
        'current_page',
        'per_page'
      )
    end
  end

  describe 'GET /api/v1/profile_users/:id' do
    let!(:profile_user) { create(:profile_user, user: user) }

    it 'retorna o perfil do usuário' do
      get "/api/v1/profile_users/#{profile_user.id}", headers: auth_headers
      expect(response).to have_http_status(:ok)

      json = response.parsed_body
      expect(json['data']['attributes']['name']).to eq(profile_user.name)
    end

    it 'retorna erro 404 se o perfil não existir' do
      get '/api/v1/profile_users/99999', headers: auth_headers
      expect(response).to have_http_status(:not_found)

      json = response.parsed_body

      expect(json['error']).to eq('Perfil não encontrado')
    end
  end

  describe 'POST /api/v1/profile_users' do
    let(:valid_params) do
      {
        profile_user: {
          name: 'John Doe',
          cpf: '12345678901',
          birth: '1990-01-01',
          street: 'Rua Exemplo',
          number: '123',
          neighborhood: 'Centro',
          city: 'São Paulo',
          state: 'SP',
          country: 'Brasil',
          zip_code: '12345678'
        }
      }
    end

    let(:invalid_params) do
      {
        profile_user: {
          name: nil,
          cpf: nil
        }
      }
    end

    it 'cria um perfil com parâmetros válidos' do
      post '/api/v1/profile_users', params: valid_params, headers: auth_headers
      expect(response).to have_http_status(:created)

      json = JSON.parse(response.body)
      expect(json['data']['attributes']['name']).to eq('John Doe')
    end

    it 'retorna erro para parâmetros inválidos' do
      post '/api/v1/profile_users', params: invalid_params, headers: auth_headers
      expect(response).to have_http_status(:unprocessable_entity)

      json = response.parsed_body
      expect(json['errors']).to include("Name can't be blank")
    end

    it 'não permite criar mais de um perfil para o mesmo usuário' do
      create(:profile_user, user: user)

      post '/api/v1/profile_users', params: valid_params, headers: auth_headers
      expect(response).to have_http_status(:unprocessable_entity)

      json = response.parsed_body
      expect(json['errors']).to include('Usuário já possui um perfil associado')
    end
  end

  describe 'PUT /api/v1/profile_user/:id' do
    let!(:profile_user) { create(:profile_user, user: user) }
    let(:valid_params) { { profile_user: { name: 'Jane Doe' } } }
    let(:invalid_params) { { profile_user: { name: nil } } }

    it 'atualiza o perfil com parâmetros válidos' do
      put "/api/v1/profile_users/#{profile_user.id}", params: valid_params, headers: auth_headers
      expect(response).to have_http_status(:ok)

      json = response.parsed_body
      expect(json['data']['attributes']['name']).to eq('Jane Doe')
    end

    it 'retorna erro para parâmetros inválidos' do
      put "/api/v1/profile_users/#{profile_user.id}", params: invalid_params, headers: auth_headers
      expect(response).to have_http_status(:unprocessable_entity)

      json = response.parsed_body
      expect(json['errors']).to include("Name can't be blank")
    end
  end

  describe 'DELETE /api/v1/profile_user/:id' do
    let!(:profile_user) { create(:profile_user, user: user) }

    it 'deleta o perfil do usuário' do
      expect {
        delete "/api/v1/profile_users/#{profile_user.id}", headers: auth_headers
      }.to change(ProfileUser, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    it 'retorna erro 404 ao tentar deletar um perfil inexistente' do
      delete '/api/v1/profile_users/9999', headers: auth_headers
      expect(response).to have_http_status(:not_found)

      json = response.parsed_body
      expect(json['error']).to eq('Perfil não encontrado')
    end
  end
end
