# frozen_string_literal: true

namespace :db do
  desc 'Create fake products'
  task create_fake_products: :environment do
    3.times do
      category = Category.create!(
        title: Faker::Commerce.department,
        description: Faker::Lorem.sentence(word_count: 5)
      )

      20.times do
        minimum_value = Faker::Commerce.price(range: 100.0..1000.0)

        Product.create!(
          lot_number: Faker::Number.unique.number(digits: 3).to_s,
          donor_name: Faker::Name.name,
          donor_phone: Faker::PhoneNumber.phone_number,
          minimum_value: minimum_value,
          description: Faker::Lorem.sentence(word_count: 10),
          auctioned: 0,
          category: category
        )
      end
    end

    puts 'Fake products have been created!'
  end
end
