# frozen_string_literal: true

class ProductFilter
  class << self
    def retrieve_all(params)
      products = Product.includes(:category)

      products = products.where(category_id: params[:category_id]) if params[:category_id].present?

      products.page(params[:page] || 1)
              .per(params[:per_page] || 12)
    end

    def search(id)
      Product.find(id)
    rescue ActiveRecord::RecordNotFound
      raise ActiveRecord::RecordNotFound, 'Produto não encontrado'
    end
  end
end
