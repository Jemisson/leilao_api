# frozen_string_literal: true

class Bid < ApplicationRecord
  belongs_to :profile_user
  belongs_to :product

  validates :value, presence: true, numericality: { greater_than: 0 }
end
