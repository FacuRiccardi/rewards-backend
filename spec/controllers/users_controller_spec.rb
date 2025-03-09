require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST #register' do
    let(:valid_attributes) do
      {
        user: {
          username: 'testuser',
          name: 'Test User',
          password: 'password123'
        }
      }
    end

    context 'with valid parameters' do
      it 'creates a new user' do
        expect {
          post :register, params: valid_attributes
        }.to change(User, :count).by(1)
      end

      it 'returns a success response with user data' do
        post :register, params: valid_attributes
        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body)
        expect(json['user']['username']).to eq('testuser')
        expect(json['user']['name']).to eq('Test User')
        expect(json['user']['points']).to be_in([ 1500, 2000, 3000 ])
      end
    end

    context 'with invalid parameters' do
      it 'returns an error response' do
        post :register, params: { user: { username: '' } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'POST #login' do
    let!(:user) { create(:user, username: 'testuser', password: 'password123') }

    context 'with valid credentials' do
      it 'returns user data' do
        post :login, params: { user: { username: 'testuser', password: 'password123' } }
        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json['user']['username']).to eq('testuser')
      end
    end

    context 'with invalid credentials' do
      it 'returns unauthorized status' do
        post :login, params: { user: { username: 'testuser', password: 'wrong' } }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #rewards' do
    let!(:user) { create(:user) }
    let!(:rewards) { create_list(:reward, 20) }

    context 'with valid credentials' do
      it 'returns paginated rewards' do
        post :rewards, params: {
          user: { username: user.username, password: user.password },
          page: 1,
          limit: 15
        }

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json['rewards'].length).to eq(15)
        expect(json['pagination']['currentPage']).to eq(1)
        expect(json['pagination']['totalPages']).to eq(2)
      end
    end
  end

  describe 'POST #redemptions' do
    let!(:user) { create(:user) }
    let!(:redemptions) { create_list(:redemption, 20, user: user) }

    context 'with valid credentials' do
      it 'returns paginated redemptions' do
        post :redemptions, params: {
          user: { username: user.username, password: user.password },
          page: 1,
          limit: 15
        }

        expect(response).to have_http_status(:ok)

        json = JSON.parse(response.body)
        expect(json['redemptions'].length).to eq(15)
        expect(json['pagination']['currentPage']).to eq(1)
        expect(json['pagination']['totalPages']).to eq(2)
      end
    end
  end

  describe 'POST #redeem' do
    let!(:user) { create(:user, points: 2000) }
    let!(:reward) { create(:reward, price: 1500) }

    context 'with valid parameters' do
      it 'creates a redemption and updates user points' do
        expect {
          post :redeem, params: {
            username: user.username,
            password: user.password,
            reward_id: reward.id
          }
        }.to change(Redemption, :count).by(1)
        .and change { user.reload.points }.by(-reward.price)

        expect(response).to have_http_status(:created)

        json = JSON.parse(response.body)
        expect(json['points']).to eq(500)
        expect(json['redemption']['rewardTitle']).to eq(reward.title)
      end
    end

    context 'with insufficient points' do
      let!(:expensive_reward) { create(:reward, price: 3000) }

      it 'returns an error' do
        post :redeem, params: {
          username: user.username,
          password: user.password,
          reward_id: expensive_reward.id
        }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Insufficient points')
      end
    end
  end
end
