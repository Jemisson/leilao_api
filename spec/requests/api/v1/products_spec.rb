# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Products API', type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) do
    token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
    { 'Authorization' => "Bearer #{token}" }
  end

  describe 'GET /api/v1/products' do
    before do
      create_list(:product, 3)
    end

    it 'retorna uma lista de produtos' do
      get '/api/v1/products', headers: auth_headers
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json['data'].size).to eq(3)
    end
  end

  describe 'GET /api/v1/products/:id' do
    let(:product) { create(:product) }

    it 'retorna o produto especificado' do
      get "/api/v1/products/#{product.id}", headers: auth_headers
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json['data']['attributes']['lot_number']).to eq(product.lot_number)
    end

    it 'retorna erro 404 se o produto não for encontrado' do
      get '/api/v1/products/9999', headers: auth_headers
      expect(response).to have_http_status(:not_found)

      json = JSON.parse(response.body)
      expect(json['error']).to eq('Produto não encontrado')
    end
  end

  describe 'POST /api/v1/products' do
    let(:valid_params) do
      {
        product: {
          lot_number: '123',
          donor_name: 'John Doe',
          donor_phone: '123456789',
          minimum_value: 100.0,
          description: 'A valuable item'
        }
      }
    end

    let(:invalid_params) do
      {
        product: {
          lot_number: nil,
          donor_name: 'John Doe',
          donor_phone: '123456789',
          minimum_value: 100.0,
          description: nil
        }
      }
    end

    it 'cria um produto com parâmetros válidos' do
      post '/api/v1/products', params: valid_params, headers: auth_headers
      expect(response).to have_http_status(:created)

      json = JSON.parse(response.body)
      expect(json['data']['attributes']['lot_number']).to eq('123')
    end

    it 'retorna erro para parâmetros inválidos' do
      post '/api/v1/products', params: invalid_params, headers: auth_headers
      expect(response).to have_http_status(:unprocessable_entity)

      json = JSON.parse(response.body)
      expect(json['errors']).to include("Lot number can't be blank", "Description can't be blank")
    end
  end

  describe 'PUT /api/v1/products/:id' do
    let!(:product) { create(:product, lot_number: '123') }
    let(:valid_params) { { product: { lot_number: '456' } } }
    let(:invalid_params) { { product: { lot_number: nil } } }

    it 'atualiza o produto com parâmetros válidos' do
      put "/api/v1/products/#{product.id}", params: valid_params, headers: auth_headers
      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json['data']['attributes']['lot_number']).to eq('456')
    end

    it 'retorna erro para parâmetros inválidos' do
      put "/api/v1/products/#{product.id}", params: invalid_params, headers: auth_headers
      expect(response).to have_http_status(:unprocessable_entity)

      json = JSON.parse(response.body)
      expect(json['errors']).to include("Lot number can't be blank")
    end
  end

  describe 'DELETE /api/v1/products/:id' do
    let!(:product) { create(:product) }

    it 'deleta o produto especificado' do
      expect {
        delete "/api/v1/products/#{product.id}", headers: auth_headers
      }.to change(Product, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    it 'retorna erro 404 ao tentar deletar um produto inexistente' do
      delete '/api/v1/products/9999', headers: auth_headers
      expect(response).to have_http_status(:not_found)

      json = JSON.parse(response.body)
      expect(json['error']).to eq('Produto não encontrado')
    end
  end
end
