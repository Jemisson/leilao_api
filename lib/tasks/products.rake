namespace :db do
  desc 'Create 10 fake products'
  task create_fake_products: :environment do
    10.times do
      Product.create!(
        lot_number: Faker::Number.unique.number(digits: 3).to_s,
        donor_name: Faker::Name.name,
        donor_phone: Faker::PhoneNumber.phone_number,
        minimum_value: Faker::Commerce.price(range: 100.0..1000.0),
        bidder_name: [Faker::Name.name, nil].sample,
        bidder_phone: [Faker::PhoneNumber.phone_number, nil].sample,
        winning_value: [Faker::Commerce.price(range: 100.0..1000.0), nil].sample,
        description: Faker::Lorem.sentence(word_count: 10)
      )
    end

    puts '10 fake products have been created!'
  end
end
