# frozen_string_literal: true

class UserService
  class << self
    def create_user(user_params, profile_user_params)
      ActiveRecord::Base.transaction do
        user = User.create!(user_params)
        user.create_profile_user!(profile_user_params)
        user
      end
    rescue ActiveRecord::RecordInvalid => e
      user = User.new(user_params)
      user.errors.add(:base, e.message)
      user
    end
  end
end
