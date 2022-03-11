class Public::RelationshipsController < ApplicationController
  
  def create
    end_user = EndUser.find(params[:end_user_id])
    current_end_user.follow(end_user)
    redirect_to request.referer
  end
  
  def destroy
    end_user = EndUser.find(params[:end_user_id])
    current_end_user.unfollow(end_user)
    redirect_to request.referer
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