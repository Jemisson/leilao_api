# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Category, type: :model do
  it 'é válido com um título' do
    category = build(:category, title: 'Tecnologia')
    expect(category).to be_valid
  end

  it 'é inválido sem título' do
    category = build(:category, title: nil)
    expect(category).not_to be_valid
    expect(category.errors[:title]).to include("can't be blank")
  end

  it 'é inválido com título duplicado (case insensitive)' do
    create(:category, title: 'Tecnologia')
    category = build(:category, title: 'tecnologia')
    expect(category).not_to be_valid
    expect(category.errors[:title]).to include('has already been taken')
  end

  it 'é válido sem descrição' do
    category = build(:category, title: 'Tecnologia', description: nil)
    expect(category).to be_valid
  end
end
