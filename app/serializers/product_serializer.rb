# frozen_string_literal: true

class ProductSerializer
  include JSONAPI::Serializer
  attributes :id, :lot_number, :donor_name, :donor_phone, :description, :auctioned, :minimum_value

  attribute :category_title do |object|
    object.category&.title
  end

  attribute :current_value do |object|
    object.winning_value || object.minimum_value
  end

  attribute :winning_name do |product|
    highest_bid = product.bids.order(value: :desc).first
    highest_bid&.profile_user&.name
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
