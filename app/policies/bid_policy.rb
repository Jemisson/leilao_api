# frozen_string_literal: true

class BidPolicy < ApplicationPolicy
  def index?
    user.admin? # Somente admins podem visualizar os lances
  end

  def create?
    user.profile_user.present? # Todos os usuários autenticados com um perfil podem dar lances
  end
end
