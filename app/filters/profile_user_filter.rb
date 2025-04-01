# frozen_string_literal: true

class ProfileUserFilter
  class << self
    def retrieve_all(params)
      ProfileUser
        .page(params[:page] || 1)
        .per(params[:per_page] || 10)
    end

    def search(id)
      ProfileUser.find(id)
    rescue ActiveRecord::RecordNotFound
      raise ActiveRecord::RecordNotFound, 'Perfil não encontrado'
    end

    def retrieve_bids(params)
      ProfileUser
        .includes(:bids)
        .find_by(user_id: params['profile_user_id'])
        .bids
        .order(id: :desc)
        .page(params[:page] || 1)
        .per(params[:per_page] || 10)
    end
  end
end
