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
  end
end
