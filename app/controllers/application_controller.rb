# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Devise::Controllers::Helpers
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def record_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def user_not_authorized
    render json: { error: 'Você não tem permissão para realizar esta ação' }, status: :forbidden
  end
end
