# frozen_string_literal: true

module Api
  module V1
    class CatalogSettingsController < ApplicationController
      before_action :authenticate_user!, except: %i[show]
      before_action :set_catalog_setting

      def show
        render json: CatalogSettingSerializer.new(@catalog_setting).serializable_hash.to_json, status: :ok
      end

      def update
        authorize @catalog_setting

        if @catalog_setting.update(catalog_setting_params)
          render json: CatalogSettingSerializer.new(@catalog_setting).serializable_hash.to_json, status: :ok
        else
          render json: { errors: @catalog_setting.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_catalog_setting
        @catalog_setting = CatalogSetting.current
      end

      def catalog_setting_params
        params.require(:catalog_setting).permit(:show_product_values)
      end
    end
  end
end
