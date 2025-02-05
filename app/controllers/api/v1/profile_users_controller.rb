# frozen_string_literal: true

module Api
  module V1
    class ProfileUsersController < ApplicationController
      before_action :authenticate_user!, except: %i[create]
      before_action :set_profile_user, only: %i[show update destroy]
      before_action :authorize_profile_user, only: %i[show update destroy]
      before_action :authorize_admin, only: %i[index destroy]

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
        user = UserService.create_user(user_params, profile_user_params)

        if user.persisted?
          render json: UserSerializer.new(user).serializable_hash.to_json, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
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

      def authorize_profile_user
        authorize @profile_user if @profile_user.present?
      end

      def authorize_admin
        render json: { error: 'Acesso não autorizado' }, status: :forbidden unless current_user&.admin?
      end

      def user_params
        params
          .require(:user)
          .permit(:email, :password, :role)
      end

      def profile_user_params
        params
          .require(:profile_user)
          .permit(:name, :cpf, :birth, :street, :number, :neighborhood, :city, :state, :country, :zip_code, :phone)
      end
    end
  end
end
