# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::CategoriesController, type: :request do
  let(:user) { create(:user) } # Criação de usuário para autenticação
  let(:auth_headers) do
    token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
    { 'Authorization' => "Bearer #{token}" }
  end

  describe 'GET /api/v1/categories' do
    let!(:eletronics_category) { create(:category, title: 'Eletrônicos', description: 'Tudo sobre tecnologia') }

    before do
      create_list(:category, 2)
    end

    it 'retorna uma lista de categorias' do
      get '/api/v1/categories', headers: auth_headers
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data'].size).to eq(3)
    end

    it 'filtra categorias por título' do
      get '/api/v1/categories', params: { title: 'Eletrônicos' }, headers: auth_headers
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data'].size).to eq(1)
      expect(json['data'][0]['attributes']['title']).to eq('Eletrônicos')
    end
  end

  describe 'GET /api/v1/categories/:id' do
    let(:category) { create(:category) }

    it 'retorna uma categoria específica' do
      get "/api/v1/categories/#{category.id}", headers: auth_headers
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data']['attributes']['title']).to eq(category.title)
    end

    it 'retorna erro 404 para categoria inexistente' do
      get '/api/v1/categories/9999', headers: auth_headers
      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('Categoria não encontrada')
    end
  end

  describe 'POST /api/v1/categories' do
    let(:valid_params) { { category: { title: 'Nova Categoria' } } }
    let(:invalid_params) { { category: { title: nil } } }

    it 'cria uma nova categoria com parâmetros válidos' do
      post '/api/v1/categories', params: valid_params, headers: auth_headers
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json['data']['attributes']['title']).to eq('Nova Categoria')
    end

    it 'retorna erro para parâmetros inválidos' do
      post '/api/v1/categories', params: invalid_params, headers: auth_headers
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json['errors']).to include("Title can't be blank")
    end
  end

  describe 'PUT /api/v1/categories/:id' do
    let(:category) { create(:category, title: 'Antigo Título') }
    let(:valid_params) { { category: { title: 'Novo Título' } } }
    let(:invalid_params) { { category: { title: nil } } }

    it 'atualiza a categoria com parâmetros válidos' do
      put "/api/v1/categories/#{category.id}", params: valid_params, headers: auth_headers
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['data']['attributes']['title']).to eq('Novo Título')
    end

    it 'retorna erro para parâmetros inválidos' do
      put "/api/v1/categories/#{category.id}", params: invalid_params, headers: auth_headers
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json['errors']).to include("Title can't be blank")
    end
  end

  describe 'DELETE /api/v1/categories/:id' do
    let!(:category) { create(:category) }

    it 'deleta uma categoria existente' do
      expect {
        delete "/api/v1/categories/#{category.id}", headers: auth_headers
      }.to change(Category, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    it 'retorna erro ao tentar deletar uma categoria inexistente' do
      delete '/api/v1/categories/9999', headers: auth_headers
      expect(response).to have_http_status(:not_found)
    end
  end
end
