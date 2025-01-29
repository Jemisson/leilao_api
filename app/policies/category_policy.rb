# frozen_string_literal: true

class CategoryPolicy < ApplicationPolicy
  def index?
    true # Todos podem visualizar a lista de categorias
  end

  def show?
    user.admin? # Apenas administradores podem visualizar detalhes de uma categoria
  end

  def create?
    user.admin? # Apenas administradores podem criar categorias
  end

  def update?
    user.admin? # Apenas administradores podem atualizar categorias
  end

  def destroy?
    user.admin? # Apenas administradores podem excluir categorias
  end
end
