class Public::EndUsersController < ApplicationController
  before_action :authenticate_end_user!
  before_action :ensure_guest_user, only: [:edit, :withdraw]

  def show
    @end_user = EndUser.find(params[:id])
    @spots = @end_user.spots.with_attached_spot_images.order(created_at: :desc).page(params[:page])
  end

  def collection
    end_user = EndUser.find(params[:id])
    favorites = Favorite.where(end_user_id: end_user.id).pluck(:spot_id)
    @favorite_spots = Spot.with_attached_spot_images.find(favorites)
    @favorite_spots = Kaminari.paginate_array(@favorite_spots).page(params[:page])
  end

  def edit
    @end_user = current_end_user
  end

  def update
    @end_user = current_end_user
    if @end_user.update(end_user_params)
      redirect_to end_user_path(@end_user)
    else
      render "edit"
    end
  end

  def withdraw
    end_user = current_end_user
    end_user.update(is_deleted: true)
    reset_session
    redirect_to root_path
  end

  private

  def end_user_params
    params.require(:end_user).permit(:name, :email, :introduction, :profile_image)
  end

  def ensure_guest_user
    end_user = current_end_user
    if end_user.email == "guest@example.com"
      redirect_to request.referer, notice: 'ゲストはアクセスできません'
    end
  end
end
