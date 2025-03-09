# Create default users
users = [
  { username: 'user', name: 'User', password: '123456', points: 2000 },
  { username: 'admin', name: 'Admin', password: '123456', points: 3000 },
  { username: 'facu', name: 'Facu', password: '123456', points: 1500 }
]

users.each do |user_data|
  User.find_or_create_by(username: user_data[:username]) do |user|
    user.assign_attributes(user_data)
    puts "User created: #{user.username}" if user.save
  end
end

# Create rewards
rewards = [
  { title: "Starbucks", subtitle: "Free grande coffee of your choice", price: 50 },
  { title: "McDonald's", subtitle: "25% off on your next purchase", price: 100 },
  { title: "Nike", subtitle: "15% discount on any item", price: 150 },
  { title: "Amazon", subtitle: "$25 gift card", price: 200 },
  { title: "Walmart", subtitle: "12 interest-free installments on electronics", price: 180 },
  { title: "Apple Store", subtitle: "6 interest-free installments on accessories", price: 250 },
  { title: "Adidas", subtitle: "20% off on all sportswear", price: 160 },
  { title: "Best Buy", subtitle: "Free wireless charger with any phone purchase", price: 300 },
  { title: "Target", subtitle: "30% off on home decor", price: 180 },
  { title: "H&M", subtitle: "Buy one get one free on basics", price: 120 },
  { title: "Subway", subtitle: "Free 6-inch sub with drink purchase", price: 90 },
  { title: "GameStop", subtitle: "$50 off on any new console", price: 400 },
  { title: "Burger King", subtitle: "Free Whopper combo meal", price: 130 },
  { title: "Spotify", subtitle: "3 months premium subscription", price: 200 },
  { title: "Netflix", subtitle: "6 months basic plan at 50% off", price: 450 },
  { title: "Under Armour", subtitle: "25% off on your purchase", price: 180 },
  { title: "Domino's Pizza", subtitle: "Buy one get one free on any pizza", price: 150 },
  { title: "Sephora", subtitle: "$30 off on purchases over $100", price: 250 },
  { title: "Costco", subtitle: "One year membership at 40% off", price: 300 },
  { title: "IKEA", subtitle: "18 interest-free installments on furniture", price: 350 },
  { title: "Sony", subtitle: "Free headphones with PS5 purchase", price: 500 },
  { title: "Samsung", subtitle: "15% off on smartphones", price: 400 },
  { title: "Dunkin' Donuts", subtitle: "Free dozen donuts", price: 120 },
  { title: "Microsoft Store", subtitle: "3 months Xbox Game Pass", price: 200 },
  { title: "Foot Locker", subtitle: "Buy one get one 50% off", price: 180 },
  { title: "KFC", subtitle: "Family bucket at half price", price: 150 },
  { title: "Disney+", subtitle: "One year subscription at 30% off", price: 350 },
  { title: "Levi's", subtitle: "40% off on jeans", price: 200 },
  { title: "Pizza Hut", subtitle: "Free large pizza with order over $30", price: 160 },
  { title: "Gap", subtitle: "25% off entire purchase", price: 140 },
  { title: "Uber", subtitle: "5 rides with 30% off", price: 250 },
  { title: "Chipotle", subtitle: "Free burrito bowl", price: 100 },
  { title: "Old Navy", subtitle: "50% off on second item", price: 120 },
  { title: "Panera Bread", subtitle: "Free breakfast combo", price: 110 },
  { title: "Dell", subtitle: "12 interest-free installments on laptops", price: 300 },
  { title: "Wendy's", subtitle: "Free Baconator with purchase", price: 130 },
  { title: "Forever 21", subtitle: "20% off entire purchase", price: 150 },
  { title: "Taco Bell", subtitle: "5 tacos for free", price: 100 },
  { title: "American Eagle", subtitle: "Buy one get one free on jeans", price: 180 },
  { title: "Five Guys", subtitle: "Free burger and fries", price: 140 },
  { title: "Zara", subtitle: "15% off on your purchase", price: 160 },
  { title: "Papa John's", subtitle: "50% off on any pizza", price: 120 },
  { title: "Uniqlo", subtitle: "30% off on outerwear", price: 170 },
  { title: "Shake Shack", subtitle: "Free shake with burger purchase", price: 90 },
  { title: "Calvin Klein", subtitle: "40% off on underwear collection", price: 150 },
  { title: "Popeyes", subtitle: "Free chicken sandwich combo", price: 110 },
  { title: "Urban Outfitters", subtitle: "25% off student discount", price: 140 },
  { title: "Chick-fil-A", subtitle: "Free chicken sandwich meal", price: 120 },
  { title: "Express", subtitle: "Buy one get one 50% off", price: 160 },
  { title: "Baskin Robbins", subtitle: "Free ice cream cake", price: 130 }
]

rewards.each do |reward_data|
  Reward.find_or_create_by(title: reward_data[:title]) do |reward|
    reward.assign_attributes(reward_data)
    puts "Reward created: #{reward.title}" if reward.save
  end
end

# Create redemptions
redemptions_data = {
  'user' => [
    { reward_title: "Starbucks", redeemed_at: 2.days.ago },
    { reward_title: "Netflix", redeemed_at: 5.days.ago },
    { reward_title: "McDonald's", redeemed_at: 1.day.ago },
    { reward_title: "Spotify", redeemed_at: 10.days.ago }
  ],
  'admin' => [
    { reward_title: "Apple Store", redeemed_at: 3.days.ago },
    { reward_title: "Nike", redeemed_at: 7.days.ago },
    { reward_title: "Amazon", redeemed_at: 1.day.ago },
    { reward_title: "Best Buy", redeemed_at: 4.days.ago },
    { reward_title: "GameStop", redeemed_at: 2.days.ago }
  ],
  'facu' => [
    { reward_title: "Burger King", redeemed_at: 6.days.ago },
    { reward_title: "Adidas", redeemed_at: 3.days.ago },
    { reward_title: "Subway", redeemed_at: 1.day.ago }
  ]
}

redemptions_data.each do |username, redemptions|
  user = User.find_by(username: username)
  redemptions.each do |redemption_data|
    reward = Reward.find_by(title: redemption_data[:reward_title])
    Redemption.create!(
      user: user,
      reward: reward,
      redeemed_at: redemption_data[:redeemed_at]
    )
    puts "Redemption created: #{username} - #{redemption_data[:reward_title]}"
  end
end
