# frozen_string_literal: true

class ProfileUserPolicy < ApplicationPolicy
  def index?
    user.admin? # Apenas administradores podem listar perfis
  end

  def show?
    user.admin? || record.user == user # Admins podem ver todos, usuários apenas seu próprio perfil
  end

  def create?
    true # Todos podem criar um perfil sem precisar estar logado
  end

  def update?
    user.admin? || record.user == user # Admins podem editar qualquer perfil, usuários só o próprio
  end

  def destroy?
    user.admin? # Apenas admins podem excluir perfis
  end
end
