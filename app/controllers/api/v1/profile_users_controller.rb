# frozen_string_literal: true

module Api
  module V1
    class ProfileUsersController < ApplicationController
      before_action :authenticate_user!, except: %i[create]
      before_action :set_profile_user, only: %i[show update destroy]
      before_action :authorize_profile_user, only: %i[show update destroy]
      before_action :authorize_admin, only: %i[index destroy]

      def index
        profiles = ProfileUserFilter.retrieve_all(params)
        render json: ProfileUserSerializer.new(
          profiles,
          meta: {
            total_count: profiles.total_count,
            total_pages: profiles.total_pages,
            current_page: profiles.current_page,
            per_page: profiles.limit_value
          }
        ).serializable_hash.to_json, status: :ok
      end

      def show
        render json: ProfileUserSerializer.new(@profile_user).serializable_hash.to_json, status: :ok
      end

      def create
        profile_user = ProfileUser.new(profile_user_params)

        if profile_user.save
          render json: ProfileUserSerializer.new(profile_user).serializable_hash.to_json, status: :created
        else
          render json: { errors: profile_user.errors.full_messages + profile_user.user&.errors&.full_messages.to_a }, status: :unprocessable_entity
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

      def bids_per_user
        bids = ProfileUserFilter.retrieve_bids(params)
        render json: BidSerializer.new(bids).serializable_hash.to_json, status: :ok
      end

      private

      def set_profile_user
        @profile_user = ProfileUserFilter.search(params[:id])
        render json: { error: 'Perfil não encontrado' }, status: :not_found unless @profile_user
      end

      def authorize_profile_user
        authorize @profile_user if @profile_user.present?
      end

      def authorize_admin
        render json: { error: 'Acesso não autorizado' }, status: :forbidden unless current_user&.admin?
      end

      def profile_user_params
        params.require(:profile_user).permit(
          :name, :cpf, :birth, :street, :number, :neighborhood, :city,
          :state, :country, :zip_code, :phone,
          user_attributes: %i[id email password role _destroy]
        )
      end
    end
  end
end
