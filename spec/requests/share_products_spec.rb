# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Share products', type: :request do
  around do |example|
    previous_frontend_url = ENV.fetch('FRONTEND_URL', nil)
    previous_api_url = ENV.fetch('API_PUBLIC_URL', nil)
    ENV['FRONTEND_URL'] = 'https://frontend.example.com'
    ENV['API_PUBLIC_URL'] = 'https://api.example.com'
    example.run
  ensure
    ENV['FRONTEND_URL'] = previous_frontend_url
    ENV['API_PUBLIC_URL'] = previous_api_url
  end

  def create_product_with_image
    product = create(:product, category: create(:category))
    product.images.attach(
      io: StringIO.new(Base64.decode64(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+/p9sAAAAASUVORK5CYII='
      )),
      filename: 'product.png',
      content_type: 'image/png'
    )
    product
  end

  describe 'GET /share/products/:id' do
    it 'uses the optimized share image URL in Open Graph tags' do
      product = create_product_with_image

      get share_product_path(product)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("https://frontend.example.com/compartilhar/produto/#{product.id}")
      expect(response.body).to include("https://frontend.example.com/produto/#{product.id}")
      expect(response.body).to include("https://api.example.com/share/products/#{product.id}/image?v=#{product.updated_at.to_i}")
      expect(response.body).to include('property="og:image"')
      expect(response.body).not_to include('/rails/active_storage/blobs/redirect')
    end
  end

  describe 'GET /compartilhar/produto/:id' do
    it 'supports frontend proxy requests that keep the pretty path' do
      product = create_product_with_image

      get "/compartilhar/produto/#{product.id}"

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("https://frontend.example.com/compartilhar/produto/#{product.id}")
    end
  end

  describe 'GET /share/products/:id/image' do
    it 'returns an optimized JPEG image' do
      product = create_product_with_image

      get share_product_image_path(product)

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq('image/jpeg')
      expect(response.body.bytesize).to be_positive
    end
  end
end
