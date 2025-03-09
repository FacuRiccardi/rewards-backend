FactoryBot.define do
  factory :redemption do
    association :user
    association :reward
    redeemed_at { Time.current }
  end
end
