# frozen_string_literal: true

class ProductSerializer
  include JSONAPI::Serializer
  attributes :lot_number, :donor_name, :donor_phone, :minimum_value, :description, :auctioned

  attribute :category_title do |object|
    object.category&.title
  end

  attribute :image_urls do |product|
    product.images.map { |image| Rails.application.routes.url_helpers.url_for(image) } if product.images.attached?
  end
end
