# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    title { |n| "Categoria #{n}" }
    description { Faker::Lorem.sentence(word_count: 10) }
  end
end
