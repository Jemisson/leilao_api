# frozen_string_literal: true

class ProductService
  class << self
    def mark_as_sold(product, params = {})
      attributes = params.slice(:bidder_name, :bidder_phone, :winning_value).merge(
        auctioned: 1,
        sold_at: product.sold_at.presence || Time.current
      )

      if product.update(attributes)
        { success: true, product: product }
      else
        { success: false, error: product.errors.full_messages.join(', ') }
      end
    end
  end
end
