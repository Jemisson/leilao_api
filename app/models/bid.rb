# frozen_string_literal: true

class Bid < ApplicationRecord
  belongs_to :profile_user
  belongs_to :product

  validates :value, presence: true, numericality: { greater_than: 0 }

  after_create :update_product_winning_value

  private

  def update_product_winning_value
    product.update!(winning_value: value) if value > product.winning_value.to_f
  end
end
