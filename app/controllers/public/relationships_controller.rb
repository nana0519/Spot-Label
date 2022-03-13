class Public::RelationshipsController < ApplicationController
  
  def create
    @end_user = EndUser.find(params[:end_user_id])
    current_end_user.follow(@end_user)
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
  
end
