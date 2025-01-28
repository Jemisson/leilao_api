# frozen_string_literal: true

class ProductService
  class << self
    def mark_as_sold(product)
      if product.update(auctioned: 1, sold_at: Time.current)
        { success: true, product: product }
      else
        { success: false, error: product.errors.full_messages.join(', ') }
      end
    end
  end
end
