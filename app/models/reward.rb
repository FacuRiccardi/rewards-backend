class Reward < ApplicationRecord
  has_many :redemptions

  validates :title, presence: true, uniqueness: true
  validates :subtitle, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def self.paginated(page: 1, limit: 15)
    offset = (page - 1) * limit
    total_count = count
    total_pages = (total_count.to_f / limit).ceil

    rewards = offset(offset).limit(limit)

    {
      rewards: rewards.as_json(except: [ :created_at, :updated_at ]),
      pagination: {
        currentPage: page,
        totalPages: total_pages
      }
    }
  end
end
