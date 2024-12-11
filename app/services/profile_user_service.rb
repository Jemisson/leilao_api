# frozen_string_literal: true

class ProfileUserService
  class << self
    def create_profile_user(params)
      ProfileUser.create(params)
    end

    def update_profile_user(params, profile_user)
      profile_user.update(params)
    end

    def destroy_profile_user(profile_user)
      profile_user.destroy
    end
  end
end
