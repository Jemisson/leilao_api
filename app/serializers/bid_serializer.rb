# frozen_string_literal: true

class BidSerializer
  include JSONAPI::Serializer

  attributes :id, :value, :created_at

  attribute :name do |bid|
    bid.profile_user.name
  end

  attribute :phone do |bid|
    bid.profile_user.phone
  end

  attribute :product do |bid|
    bid.product.id
  end
end
