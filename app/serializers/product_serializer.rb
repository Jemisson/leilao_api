# frozen_string_literal: true

class ProductSerializer
  include JSONAPI::Serializer
  attributes :lot_number, :donor_name, :donor_phone, :minimum_value, :bidder_name, :bidder_phone, :winning_value, :description
end
