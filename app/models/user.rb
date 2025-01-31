# frozen_string_literal: true

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  ROLES = %w[admin user].freeze

  validates :role, inclusion: { in: ROLES, message: "%{value} não é um papel válido" }, allow_nil: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_one :profile_user, dependent: :destroy

  before_create :set_jti
  before_create :set_default_role

  def admin?
    role == 'admin'
  end

  def user?
    role == 'user'
  end

  def set_jti
    self.jti ||= SecureRandom.uuid
  end

  def jwt_payload
    super.merge({ role: role })
  end

  def self.jwt_revoked?(payload, user)
    user.jti != payload['jti']
  end

  def self.revoke_jwt(_payload, user)
    user.update_column(:jti, SecureRandom.uuid) # rubocop:disable Rails/SkipsModelValidations
  end

  private

  def set_default_role
    self.role ||= 'user'
  end
end
