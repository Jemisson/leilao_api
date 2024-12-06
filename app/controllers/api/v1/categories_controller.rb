# frozen_string_literal: true

module Api
  module V1
    class CategoriesController < ApplicationController
      before_action :set_category, only: %i[show update destroy]

      def index
        categories = CategoryFilter.retrieve_all(filter_params)
        render json: CategorySerializer.new(
          categories,
          meta: {
            total_count: categories.total_count,
            total_pages: categories.total_pages,
            current_page: categories.current_page,
            per_page: categories.limit_value
          }
        ), status: :ok
      end

      def show
        render json: CategorySerializer.new(@category).serializable_hash.to_json, status: :ok
      end

      def create
        category = CategoryService.create_category(category_params)
        if category.persisted?
          render json: CategorySerializer.new(category).serializable_hash.to_json, status: :created
        else
          render json: { errors: category.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if CategoryService.update_category(category_params, @category)
          render json: CategorySerializer.new(@category).serializable_hash.to_json, status: :ok
        else
          render json: { errors: @category.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        if CategoryService.destroy_category(@category)
          head :no_content
        else
          render json: { errors: ['Não foi possível apagar a categoria'] }, status: :unprocessable_entity
        end
      end

      private

      def set_category
        @category = CategoryFilter.search(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Categoria não encontrada' }, status: :not_found
      end

      def category_params
        params.require(:category).permit(:title, :description)
      end

      def filter_params
        params.permit(:title, :description)
      end
    end
  end
end
