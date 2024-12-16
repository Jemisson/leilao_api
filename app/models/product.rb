# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :category
  validates :lot_number, :description, presence: true
end
