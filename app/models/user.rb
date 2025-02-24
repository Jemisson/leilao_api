# frozen_string_literal: true

class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  ROLES = %w[admin user].freeze

  validates :role, inclusion: { in: ROLES, message: "%{value} não é um papel válido" }, allow_nil: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_one :profile_user, dependent: :destroy

  before_create :set_jti
  before_create :set_default_role

  accepts_nested_attributes_for :profile_user

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
    super.merge({ id: id, role: role, name: profile_user&.name })
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
