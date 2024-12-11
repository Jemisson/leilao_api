# frozen_string_literal: true

FactoryBot.define do
  factory :profile_user do
    association :user
    name { Faker::Name.name }
    cpf { Faker::Number.number(digits: 11) }
    birth { Faker::Date.birthday(min_age: 18, max_age: 65) }
    street { Faker::Address.street_name }
    number { Faker::Address.building_number }
    neighborhood { Faker::Address.community }
    city { Faker::Address.city }
    state { Faker::Address.state_abbr }
    country { Faker::Address.country }
    zip_code { Faker::Address.zip_code }
  end
end
