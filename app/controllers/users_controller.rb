class UsersController < ApplicationController
  # POST /rewards
  def rewards
    @user = User.find_by(username: rewards_params[:username], password: rewards_params[:password])

    if @user
      page = (params[:page] || 1).to_i
      limit = (params[:limit] || 15).to_i
      render json: Reward.paginated(page: page, limit: limit)
    else
      render json: { error: "Invalid username or password" }, status: :unauthorized
    end
  end

  # POST /redemptions
  def redemptions
    @user = User.find_by(username: redemptions_params[:username], password: redemptions_params[:password])

    if @user
      page = (params[:page] || 1).to_i
      limit = (params[:limit] || 15).to_i
      render json: Redemption.paginated_for_user(@user, page: page, limit: limit)
    else
      render json: { error: "Invalid username or password" }, status: :unauthorized
    end
  end

  # POST /register
  def register
    @user = User.new(register_params)
    @user.points = [ 1500, 2000, 3000 ].sample # Random points from these values

    if @user.save
      response_data = {
        user: @user.as_json(except: [ :id, :created_at, :updated_at ])
      }
      render json: response_data, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /login
  def login
    @user = User.find_by(username: login_params[:username], password: login_params[:password])

    if @user
      response_data = {
        user: @user.as_json(except: [ :id, :created_at, :updated_at ])
      }
      render json: response_data, status: :ok
    else
      render json: { error: "Invalid username or password" }, status: :unauthorized
    end
  end

  # POST /redeem
  def redeem
    @user = User.find_by(username: redeem_params[:username], password: redeem_params[:password])

    unless @user
      return render json: { error: "Invalid credentials" }, status: :unauthorized
    end

    @reward = Reward.find_by(id: redeem_params[:reward_id])

    unless @reward
      return render json: { error: "Reward not found" }, status: :not_found
    end

    if @user.points < @reward.price
      return render json: { error: "Insufficient points" }, status: :unprocessable_entity
    end

    @redemption = Redemption.new(
      user: @user,
      reward: @reward,
      redeemed_at: Time.current
    )

    if @redemption.save
      @user.update(points: @user.points - @reward.price)

      response_data = {
        points: @user.points,
        redemption: {
          rewardTitle: @reward.title,
          rewardSubtitle: @reward.subtitle,
          redeemedAt: @redemption.redeemed_at
        }
      }
      render json: response_data, status: :created
    else
      render json: { errors: @redemption.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
    def register_params
      params.require(:user).permit(:username, :name, :password)
    end

    def login_params
      params.require(:user).permit(:username, :password)
    end

    def redemptions_params
      params.require(:user).permit(:username, :password)
    end

    def rewards_params
      params.require(:user).permit(:username, :password)
    end

    def redeem_params
      params.permit(:username, :password, :reward_id)
    end
end
