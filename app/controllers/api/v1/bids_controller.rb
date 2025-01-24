# frozen_string_literal: true

module Api
  module V1
    class BidsController < ApplicationController
      before_action :authenticate_user!

      def index
        bids = BidFilter.retrieve_all(params)

        render json: BidSerializer.new(
          bids,
          meta: {
            total_count: bids.total_count,
            total_pages: bids.total_pages,
            current_page: bids.current_page,
            per_page: bids.limit_value
          }
        ).serializable_hash.to_json, status: :ok
      end

      def create
        bid = current_user.profile_user.bids.new(bid_params)

        if bid.save
          render json: { message: 'Lance registrado com sucesso!', bid: bid }, status: :created
        else
          render json: { errors: bid.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def bid_params
        params.require(:bid).permit(:product_id, :value, :profile_user_id)
      end
    end
  end
end
