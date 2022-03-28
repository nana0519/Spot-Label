class Public::RelationshipsController < ApplicationController
  before_action :authenticate_end_user!
  before_action :ensure_guest_user, only: [:create, :destroy]

  def create
    @end_user = EndUser.find(params[:end_user_id])
    current_end_user.follow(@end_user)
    @end_user.create_notification_follow(current_end_user)
  end

  def destroy
    @end_user = EndUser.find(params[:end_user_id])
    current_end_user.unfollow(@end_user)
  end

  def followings
    end_user = EndUser.find(params[:end_user_id])
    @end_users = end_user.following_end_user
  end

  def followers
    end_user = EndUser.find(params[:end_user_id])
    @end_users = end_user.follower_end_user
  end

  private

  def ensure_guest_user
    end_user = current_end_user
    if end_user.email == "guest@example.com"
      redirect_to request.referer, notice: 'ゲストはfollowできません'
    end
  end
end
