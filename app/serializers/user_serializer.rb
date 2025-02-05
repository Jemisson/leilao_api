# frozen_string_literal: true

class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :role

  attribute :profile do |user|
    ProfileUserSerializer.new(user.profile_user).serializable_hash if user.profile_user.present?
  end
end
