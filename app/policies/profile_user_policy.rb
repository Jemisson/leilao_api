# frozen_string_literal: true

class ProfileUserPolicy < ApplicationPolicy
  def index?
    user.admin? # Apenas administradores podem listar perfis de usuários
  end

  def show?
    user.admin? # Apenas administradores podem visualizar perfis de usuários
  end

  def create?
    user.admin? # Apenas administradores podem criar perfis de usuários
  end

  def update?
    user.admin? # Apenas administradores podem atualizar perfis de usuários
  end

  def destroy?
    user.admin? # Apenas administradores podem excluir perfis de usuários
  end
end
