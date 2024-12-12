# frozen_string_literal: true

class ProductFilter
  class << self
    def retrieve_all(params)
      Product
        .page(params[:page] || 1)
        .per(params[:per_page] || 12)
    end

    def search(id)
      Product.find(id)
    rescue ActiveRecord::RecordNotFound
      raise ActiveRecord::RecordNotFound, 'Produto não encontrado'
    end
  end
end
