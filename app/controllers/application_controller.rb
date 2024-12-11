# frozen_string_literal: true

class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  # before_action :authenticate_user!

  private

  def record_not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end
end
