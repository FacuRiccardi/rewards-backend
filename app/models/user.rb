class User < ApplicationRecord
  has_many :redemptions

  validates :username, presence: true, uniqueness: true, length: { minimum: 4 }
  validates :name, presence: true, length: { minimum: 4 }
  validates :password, presence: true, length: { minimum: 4 }
  validates :points, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
