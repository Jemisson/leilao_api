# frozen_string_literal: true

class CatalogSetting < ApplicationRecord
  validates :show_product_values, inclusion: { in: [true, false] }

  def self.current
    first_or_create!(show_product_values: true)
  end
end
