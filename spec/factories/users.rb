FactoryBot.define do
  factory :user do
    username { Faker::Internet.unique.username }
    name { Faker::Name.name }
    password { Faker::Internet.password(min_length: 6) }
    points { [ 1500, 2000, 3000 ].sample }
  end
end
