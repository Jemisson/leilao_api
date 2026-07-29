# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductSerializer do
  let(:product) { build_stubbed(:product, minimum_value: 100, winning_value: 150) }

  it 'serializa valores do produto quando a configuração permite' do
    attributes = described_class
                 .new(product, params: { show_product_values: true })
                 .serializable_hash
                 .dig(:data, :attributes)

    expect(attributes).to include(:minimum_value, :current_value)
  end

  it 'omite valores do produto quando a configuração desabilita a exibição' do
    attributes = described_class
                 .new(product, params: { show_product_values: false })
                 .serializable_hash
                 .dig(:data, :attributes)

    expect(attributes).not_to include(:minimum_value, :current_value)
  end
end
