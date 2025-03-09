require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:points) }
    it { should validate_numericality_of(:points).is_greater_than_or_equal_to(0) }
  end

  describe 'associations' do
    it { should have_many(:redemptions) }
  end
end
