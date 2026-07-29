# frozen_string_literal: true

class CatalogSettingPolicy < ApplicationPolicy
  def show?
    true
  end

  def update?
    user.admin?
  end
end
