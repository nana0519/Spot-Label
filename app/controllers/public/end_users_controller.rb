class Public::EndUsersController < ApplicationController
  
  def mypage
    @spots = Spot.all
    @tags = Tag.all
  end
  
  def show
    @end_user = EndUser.find(params[:id])
    @spots = @end_user.spots.order(created_at: :desc).page(params[:page])
  end
  
  def withdraw
    end_user = current_end_user
    end_user.update(is_deleted: true)
    reset_session
    redirect_to root_path
  end
end
