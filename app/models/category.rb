# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  validates :title, presence: true, uniqueness: { case_sensitive: false }
end
