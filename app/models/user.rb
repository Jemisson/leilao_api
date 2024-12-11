# frozen_string_literal: true

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_one :profile_user, dependent: :destroy

  before_create :set_jti

  def set_jti
    self.jti ||= SecureRandom.uuid
  end

  def self.jwt_revoked?(payload, user)
    user.jti != payload['jti']
  end

  def self.revoke_jwt(_payload, user)
    user.update_column(:jti, SecureRandom.uuid) # rubocop:disable Rails/SkipsModelValidations
  end
end
