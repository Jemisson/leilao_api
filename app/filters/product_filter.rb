# frozen_string_literal: true

class ProductFilter
  class << self
    def retrieve_all(params)
      products = Product
                 .includes(:category)
                 .includes(:bids)
                 .with_attached_images
                 .order(id: :desc)

      products = filter_by_category(products, params[:category_id])
      products = filter_by_auction_status(products, params[:auctioned])
      paginate(products, params[:page], params[:per_page])
    end

    def search(id)
      Product.find(id)
    rescue ActiveRecord::RecordNotFound
      raise ActiveRecord::RecordNotFound, 'Produto não encontrado'
    end

    def retireve_filtered_produducts(params)
      products = Product
                 .includes(:category)
                 .includes(:bids)
                 .with_attached_images
                 .order(id: :desc)

      products = filter_by_query(products, params[:query], params[:auctioned])
      paginate(products, params[:page], params[:per_page])
    end

    private

    def filter_by_category(products, category_id)
      return products if category_id.blank?

      products.where(category_id: category_id)
    end

    def filter_by_auction_status(products, auctioned)
      auctioned_value = auctioned.to_i
      return products unless auctioned_value.in?([0, 1])

      products.where(auctioned: auctioned)
    end

    def filter_by_query(scope, query, auctioned)
      return scope if query.blank?

      sanitized_query = "%#{query.downcase}%"

      scope.joins(:category).where(auctioned: auctioned).where(
        "LOWER(products.lot_number) LIKE :query OR \
         LOWER(products.description) LIKE :query OR \
         CAST(products.minimum_value AS TEXT) LIKE :query OR \
         CAST(products.winning_value AS TEXT) LIKE :query OR \
         LOWER(categories.title) LIKE :query",
        query: sanitized_query
      )
    end

    def paginate(products, page, per_page)
      products.page(page || 1).per(per_page || 12)
    end
  end
end
