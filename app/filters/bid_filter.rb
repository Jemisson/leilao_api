# frozen_string_literal: true

class BidFilter
  class << self
    def retrieve_all(params)
      bids = Bid
             .includes(:product, :profile_user)

      bids = bids.where(product_id: params[:product_id]) if params[:product_id].present?

      per_page = params[:per_page].presence || 10

      bids.order(id: :desc)
          .page(params[:page] || 1)
          .per(per_page)
    end
  end
end
