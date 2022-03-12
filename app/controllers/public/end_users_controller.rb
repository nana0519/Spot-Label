class Public::EndUsersController < ApplicationController

  def show
    @end_user = EndUser.find(params[:id])
    @spots = @end_user.spots.order(created_at: :desc).page(params[:page])
  end

  def collection
    end_user = EndUser.find(params[:id])
    favorites = Favorite.where(end_user_id: end_user.id).pluck(:spot_id)
    @favorite_spots = Spot.find(favorites)
    @favorite_spots = Kaminari.paginate_array(@favorite_spots).page(params[:page])
  end

  def edit
    @end_user = current_end_user
  end

  def update
    current_end_user.update(end_user_params)
    redirect_to end_user_path(current_end_user)
  end

  def withdraw
    end_user = current_end_user
    end_user.update(is_deleted: true)
    reset_session
    redirect_to root_path
  end

  private

  def end_user_params
    params.require(:end_user).permit(:name, :introduction, :profile_image)
  end

end
