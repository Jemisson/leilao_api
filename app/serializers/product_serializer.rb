# frozen_string_literal: true

class ProductSerializer
  include JSONAPI::Serializer
  attributes :id, :lot_number, :donor_name, :donor_phone, :minimum_value, :description, :auctioned

  attribute :category_title do |object|
    object.category&.title
  end

  attribute :images do |product|
    if product.images.attached?
      product.images.map do |image|
        {
          id: image.id,
          url: Rails.application.routes.url_helpers.url_for(image)
        }
      end
    end
  end
end
