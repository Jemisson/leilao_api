# frozen_string_literal: true

class ProductSerializer
  include JSONAPI::Serializer
  attributes :lot_number, :donor_name, :donor_phone, :minimum_value, :bidder_name, :bidder_phone
  attributes :winning_value, :description, :name, :auctioned

  attribute :category_title do |object|
    object.category&.title
  end
end
