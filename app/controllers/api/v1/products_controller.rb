# frozen_string_literal: true

module Api
  module V1
    class ProductsController < ApplicationController
      before_action :authenticate_user!, except: %i[index show search]
      before_action :set_product, only: %i[show update destroy destroy_image mark_as_sold]
      before_action :authorize_product, only: %i[show update destroy destroy_image mark_as_sold]

      def index
        products = ProductFilter.retrieve_all(params)
        render json: product_serializer(
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
        render json: product_serializer(@product).serializable_hash.to_json, status: :ok
      end

      def create
        @product = Product.new(product_params)
        authorize @product

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
        @product.destroy!
        head :no_content
      end

      def destroy_image
        image = @product.images.find_by(id: params[:image_id])
        if image
          image.purge
          render json: { message: 'Imagem excluída com sucesso!' }, status: :ok
        else
          render json: { error: 'Imagem não encontrada' }, status: :not_found
        end
      end

      def mark_as_sold
        result = ProductService.mark_as_sold(@product, mark_as_sold_params)
        if result[:success]
          render json: { message: 'Arremate salvo com sucesso!', product: result[:product] }, status: :ok
        else
          render json: { error: result[:error] }, status: :unprocessable_entity
        end
      end

      def search
        products = ProductFilter.retireve_filtered_produducts(params)
        render json: product_serializer(
          products, meta: {
            total_count: products.total_count,
            total_pages: products.total_pages,
            current_page: products.current_page,
            per_page: products.limit_value
          }
        ).serializable_hash.to_json, status: :ok
      end

      private

      def set_product
        id = params[:id] || params[:product_id]
        @product = ProductFilter.search(id)
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Produto não encontrado' }, status: :not_found
      end

      def authorize_product
        authorize @product
      end

      def attach_images
        params[:images].each { |image| @product.images.attach(image) }
      end

      def product_serializer(record, options = {})
        params = { show_product_values: CatalogSetting.current.show_product_values }
        ProductSerializer.new(record, { params: params }.merge(options))
      end

      def mark_as_sold_params
        params.fetch(:product, params).permit(:bidder_name, :bidder_phone, :winning_value)
      end

      def product_params
        params
          .require(:product)
          .permit(:lot_number, :link_video, :donor_name, :donor_phone, :minimum_value,
                  :bidder_name, :bidder_phone, :winning_value, :description,
                  :auctioned, :featured, :category_id, images: [])
      end
    end
  end
end
