# frozen_string_literal: true

module Api
  module V1
    class DashboardController < ApplicationController
      def index
        total_products = Product.count
        products_auctioned = Product.where(auctioned: 1).count
        products_not_auctioned = Product.where(auctioned: 0).count

        total_users = User.where(role: "user").count

        total_minimum_value = Product.sum(:minimum_value)
        total_winning_value = Product.where(auctioned: 1).sum(:winning_value)

        render json: {
          total_products: total_products,
          products_auctioned: products_auctioned,
          products_not_auctioned: products_not_auctioned,
          total_users: total_users,
          total_minimum_value: total_minimum_value.to_f,
          total_winning_value: total_winning_value.to_f
        }
      end
    end
  end
end
