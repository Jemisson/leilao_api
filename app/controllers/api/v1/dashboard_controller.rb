# frozen_string_literal: true

module Api
  module V1
    class DashboardController < ApplicationController
      def index
        render json: dashboard_data
      end

      private

      def dashboard_data
        {
          total_products: Product.count,
          products_auctioned: Product.where(auctioned: 1).count,
          products_not_auctioned: Product.where(auctioned: 0).count,
          total_users: User.where(role: 'user').count,
          total_minimum_value: Product.sum(:minimum_value).to_f,
          total_winning_value: Product.where(auctioned: 1).sum(:winning_value).to_f,
          auctioned_products_by_day: auctioned_products_by_day
        }
      end

      def auctioned_products_by_day
        Product
          .where(auctioned: 1)
          .where.not(sold_at: [nil, ''])
          .group(sold_at_date_sql)
          .order(sold_at_date_sql)
          .count
          .map { |date, total| { date: date.iso8601, total: total } }
      end

      def sold_at_date_sql
        Arel.sql('DATE(products.sold_at::timestamp)')
      end
    end
  end
end
