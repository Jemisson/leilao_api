# frozen_string_literal: true

class ProfileUser < ApplicationRecord
  belongs_to :user
  has_many :bids, dependent: :destroy

  validates :user_id, uniqueness: { message: 'já possui um perfil associado' } # rubocop:disable Rails/I18nLocaleTexts
  validates :name, :cpf, :birth, presence: true
  validates :cpf, format: { with: /\A\d{11}\z/, message: 'deve conter 11 dígitos' } # rubocop:disable Rails/I18nLocaleTexts

  accepts_nested_attributes_for :user
end
