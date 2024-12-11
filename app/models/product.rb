# frozen_string_literal: true

class Product < ApplicationRecord
  validates :lot_number, :description, presence: true
end
