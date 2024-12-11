# frozen_string_literal: true

class ProfileUser < ApplicationRecord
  belongs_to :user

  validates :user_id, uniqueness: { message: 'já possui um perfil associado' }
  validates :name, :cpf, :birth, presence: true
  validates :cpf, format: { with: /\A\d{11}\z/, message: 'deve conter 11 dígitos' } # rubocop:disable Rails/I18nLocaleTexts
end
