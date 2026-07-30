# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User password', type: :request do
  def auth_headers(user)
    token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
    { 'Authorization' => "Bearer #{token}" }
  end

  describe 'PATCH /api/v1/users/password' do
    it 'allows the authenticated user to change their own password' do
      user = create(:user, password: 'old-password', password_confirmation: 'old-password')

      patch '/api/v1/users/password',
            params: {
              user: {
                current_password: 'old-password',
                password: 'new-password',
                password_confirmation: 'new-password'
              }
            },
            headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      expect(response.parsed_body['message']).to eq('Senha alterada com sucesso!')
      expect(user.reload.valid_password?('new-password')).to be(true)
    end

    it 'does not allow changing another user password' do
      user = create(:user, password: 'user-password', password_confirmation: 'user-password')
      other_user = create(:user, password: 'other-password', password_confirmation: 'other-password')

      patch '/api/v1/users/password',
            params: {
              id: other_user.id,
              user_id: other_user.id,
              user: {
                id: other_user.id,
                current_password: 'other-password',
                password: 'new-password',
                password_confirmation: 'new-password'
              }
            },
            headers: auth_headers(user)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(user.reload.valid_password?('new-password')).to be(false)
      expect(other_user.reload.valid_password?('other-password')).to be(true)
    end

    it 'requires authentication' do
      patch '/api/v1/users/password',
            params: {
              user: {
                current_password: 'old-password',
                password: 'new-password',
                password_confirmation: 'new-password'
              }
            }

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
