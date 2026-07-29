# frozen_string_literal: true

class ProductFilter
  class << self
    def retrieve_all(params)
      products = Product
                 .includes(:category, bids: :profile_user)
                 .with_attached_images

      products = filter_by_category(products, params[:category_id])
      products = filter_by_auction_status(products, params[:auctioned])
      paginate(order_catalog(products, params), params[:page], params[:per_page])
    end

    def search(id)
      Product
        .includes(:category, bids: :profile_user)
        .with_attached_images
        .find(id)
    rescue ActiveRecord::RecordNotFound
      raise ActiveRecord::RecordNotFound, 'Produto não encontrado'
    end

    def retireve_filtered_produducts(params)
      products = Product
                 .includes(:category, bids: :profile_user)
                 .with_attached_images

      products = filter_by_category(products, params[:category_id])
      products = filter_by_query(products, params[:query], params[:auctioned])
      paginate(order_catalog(products, params), params[:page], params[:per_page])
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

    def order_catalog(products, params)
      products = products.order(featured: :desc)
      return order_by_lot_number(products, params) if order_by_lot_number?(params)

      products.order(updated_at: :desc)
    end

    def order_by_lot_number(products, params)
      direction = order_direction(params).to_s.upcase

      products.order(
        Arel.sql("regexp_replace(products.lot_number, '\\d+', '', 'g') #{direction}"),
        Arel.sql("NULLIF(regexp_replace(products.lot_number, '\\D', '', 'g'), '')::numeric #{direction} NULLS LAST"),
        Arel.sql("products.lot_number #{direction}")
      )
    end

    def order_by_lot_number?(params)
      params[:order_by].in?(%w[lot lot_number])
    end

    def order_direction(params)
      params[:order_direction] == 'asc' ? :asc : :desc
    end

    def paginate(products, page, per_page)
      products.page(page || 1).per(per_page || 12)
    end
  end
end
