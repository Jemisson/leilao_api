# frozen_string_literal: true

class ProductSerializer
  include JSONAPI::Serializer
  SHOW_PRODUCT_VALUES = proc { |_product, params| params&.fetch(:show_product_values, true) != false }

  attributes :id, :lot_number, :link_video, :donor_name, :donor_phone, :description, :auctioned, :featured,
             :bidder_name, :bidder_phone

  attribute :minimum_value, if: SHOW_PRODUCT_VALUES, &:minimum_value

  attribute :category_id do |object|
    object.category&.id
  end

  attribute :category_title do |object|
    object.category&.title
  end

  attribute :current_value, if: SHOW_PRODUCT_VALUES do |object|
    object.winning_value || object.minimum_value
  end

  attribute :winning_name do |product|
    highest_bid =
      if product.association(:bids).loaded?
        product.bids.max_by(&:value)
      else
        product.bids.includes(:profile_user).order(value: :desc).first
      end

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
