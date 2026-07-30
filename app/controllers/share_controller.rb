class ShareController < ActionController::Base
  helper_method :frontend_url, :share_url, :product_url, :share_image_url

  def product
    @product = Product.with_attached_images.find(params[:id])
    render layout: false
  end

  def product_image
    product = Product.with_attached_images.find(params[:id])
    image = product.share_image

    return head :not_found unless image

    if (variant = product.share_image_variant)
      expires_in 1.hour, public: true
      send_data variant.processed.download, type: 'image/jpeg', disposition: 'inline'
    else
      redirect_to rails_blob_url(image, host: request.base_url), allow_other_host: false
    end
  end

  private

  def frontend_url
    ENV.fetch('FRONTEND_URL') { default_frontend_url }.delete_suffix('/')
  end

  def api_url
    ENV.fetch('API_PUBLIC_URL') { "#{request.protocol}#{request.host_with_port}" }.delete_suffix('/')
  end

  def default_frontend_url
    return 'http://localhost:5173' unless Rails.env.production?

    "#{request.protocol}#{request.host_with_port}"
  end

  def share_url(product)
    "#{frontend_url}/compartilhar/produto/#{product.id}"
  end

  def product_url(product)
    "#{frontend_url}/produto/#{product.id}"
  end

  def share_image_url(product)
    "#{api_url}/share/products/#{product.id}/image?v=#{product.updated_at.to_i}"
  end
end
