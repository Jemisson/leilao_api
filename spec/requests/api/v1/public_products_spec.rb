# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Public products API', type: :request do
  describe 'GET /api/v1/products/:id' do
    it 'returns a product without authentication' do
      product = create(:product, category: create(:category))

      get "/api/v1/products/#{product.id}"

      expect(response).to have_http_status(:ok)

      json = JSON.parse(response.body)
      expect(json.dig('data', 'id')).to eq(product.id.to_s)
      expect(json.dig('data', 'attributes', 'lot_number')).to eq(product.lot_number)
    end
  end
end
