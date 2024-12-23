# frozen_string_literal: true

module Api
  module V1
    class ProductsController < ApplicationController
      before_action :set_product, only: %i[show update destroy]

      def index
        products = ProductFilter.retrieve_all(params)
        render json: ProductSerializer.new(
          products,
          meta: {
            total_count: products.total_count,
            total_pages: products.total_pages,
            current_page: products.current_page,
            per_page: products.limit_value
          }
        ).serializable_hash.to_json, status: :ok
      end

      def show
        render json: ProductSerializer.new(@product).serializable_hash.to_json, status: :ok
      end

      def create
        @product = Product.new(product_params)
        if @product.save
          attach_images if params[:images].present?
          render json: ProductSerializer.new(@product).serializable_hash.to_json, status: :created
        else
          render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @product.update(product_params)
          attach_images if params[:images].present?
          render json: ProductSerializer.new(@product).serializable_hash.to_json, status: :ok
        else
          render json: { errors: @product.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @product.destroy
        head :no_content
      end

      private

      def set_product
        @product = Product.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Produto não encontrado' }, status: :not_found
      end

      def attach_images
        params[:images].each do |image|
          @product.images.attach(image)
        end
      end

      def product_params
        params
          .require(:product)
          .permit(:lot_number, :donor_name, :donor_phone, :minimum_value,
                  :bidder_name, :bidder_phone, :winning_value, :description,
                  :name, :auctioned, :category_id, images: [])
      end
    end
  end
end
