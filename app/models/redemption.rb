class Redemption < ApplicationRecord
  belongs_to :user
  belongs_to :reward

  validates :redeemed_at, presence: true
  validates :user_id, presence: true
  validates :reward_id, presence: true

  def self.paginated_for_user(user, page: 1, limit: 15)
    offset = (page - 1) * limit
    total_count = where(user: user).count
    total_pages = (total_count.to_f / limit).ceil

    redemptions = where(user: user)
                   .includes(:reward)
                   .order(redeemed_at: :desc)
                   .offset(offset)
                   .limit(limit)

    {
      redemptions: redemptions.map { |redemption|
        {
          rewardTitle: redemption.reward.title,
          rewardSubtitle: redemption.reward.subtitle,
          redeemedAt: redemption.redeemed_at
        }
      },
      pagination: {
        currentPage: page,
        totalPages: total_pages
      }
    }
  end
end
