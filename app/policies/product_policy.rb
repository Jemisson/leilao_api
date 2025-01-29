# frozen_string_literal: true

class ProductPolicy < ApplicationPolicy
  def index?
    true # Todos podem visualizar a listagem de produtos
  end

  def show?
    true # Todos podem visualizar um produto específico
  end

  def create?
    user.admin? # Apenas administradores podem criar
  end

  def update?
    user.admin? # Apenas administradores podem editar
  end

  def destroy?
    user.admin? # Apenas administradores podem excluir
  end

  def destroy_image?
    user.admin? # Apenas administradores podem excluir imagens
  end

  def mark_as_sold?
    user.admin? # Apenas administradores podem marcar como vendido
  end
end
