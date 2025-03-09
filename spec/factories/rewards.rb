FactoryBot.define do
  factory :reward do
    title { Faker::Commerce.unique.product_name }
    subtitle { Faker::Marketing.buzzwords }
    price { Faker::Number.between(from: 500, to: 3000) }
  end
end
