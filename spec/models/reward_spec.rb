require 'rails_helper'

RSpec.describe Reward, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_uniqueness_of(:title) }
    it { should validate_presence_of(:subtitle) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than_or_equal_to(0) }
  end

  describe 'associations' do
    it { should have_many(:redemptions) }
  end

  describe '.paginated' do
    before { create_list(:reward, 20) }

    it 'returns paginated results' do
      result = described_class.paginated(page: 1, limit: 15)

      expect(result[:rewards].length).to eq(15)
      expect(result[:pagination][:currentPage]).to eq(1)
      expect(result[:pagination][:totalPages]).to eq(2)
    end
  end
end
