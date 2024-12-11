# frozen_string_literal: true

module Api
  module V1
    class ProfileUsersController < ApplicationController
      before_action :set_profile_user, only: %i[show update destroy]

      def index
        profile = ProfileUserFilter.retrieve_all(params)
        render json: ProfileUserSerializer.new(
          profile,
          meta: {
            total_count: profile.total_count,
            total_pages: profile.total_pages,
            current_page: profile.current_page,
            per_page: profile.limit_value
          }
        ).serializable_hash.to_json, status: :ok
      end

      def show
        render json: ProfileUserSerializer.new(@profile_user).serializable_hash.to_json, status: :ok
      end

      def create
        if current_user.profile_user.present?
          render json: { errors: ['Usuário já possui um perfil associado'] }, status: :unprocessable_entity
          return
        end

        @profile_user = current_user.build_profile_user(profile_user_params)
        if @profile_user.save
          render json: ProfileUserSerializer.new(@profile_user).serializable_hash.to_json, status: :created
        else
          render json: { errors: @profile_user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @profile_user.update(profile_user_params)
          render json: ProfileUserSerializer.new(@profile_user).serializable_hash.to_json, status: :ok
        else
          render json: { errors: @profile_user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @profile_user.destroy
        head :no_content
      end

      private

      def set_profile_user
        @profile_user = ProfileUserFilter.search(params[:id])
      end

      def profile_user_params
        params
          .require(:profile_user)
          .permit(:name, :cpf, :birth, :street, :number, :neighborhood, :city, :state, :country, :zip_code)
      end
    end
  end
end
