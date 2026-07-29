# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Catalog Settings API', type: :request do
  let(:admin) { create(:user, role: 'admin') }
  let(:user) { create(:user, role: 'user') }

  def auth_headers(record)
    token = Warden::JWTAuth::UserEncoder.new.call(record, :user, nil).first
    { 'Authorization' => "Bearer #{token}" }
  end

  it 'retorna a configuração sem exigir autenticação' do
    get '/api/v1/catalog_setting'

    expect(response).to have_http_status(:ok)
    expect(response.parsed_body.dig('data', 'attributes')).to include('show_product_values' => true)
  end

  describe 'PATCH /api/v1/catalog_setting' do
    it 'permite que admin atualize a exibição de valores dos produtos' do
      params = { catalog_setting: { show_product_values: false } }
      patch '/api/v1/catalog_setting', params: params, headers: auth_headers(admin)

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body.dig('data', 'attributes')).to include('show_product_values' => false)
    end

    it 'bloqueia atualização para usuário comum' do
      params = { catalog_setting: { show_product_values: false } }
      patch '/api/v1/catalog_setting', params: params, headers: auth_headers(user)

      expect(response).to have_http_status(:forbidden)
    end
  end
end
