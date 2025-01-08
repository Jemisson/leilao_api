# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :category
  has_many_attached :images
  has_many :bids, dependent: :destroy
  validates :lot_number, :description, presence: true
end
