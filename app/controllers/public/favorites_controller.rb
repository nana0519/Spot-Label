class Public::FavoritesController < ApplicationController
  before_action :authenticate_end_user!
  before_action :ensure_guest_user

  def create
    @spot = Spot.find(params[:spot_id])
    favorite = current_end_user.favorites.new(spot_id: @spot.id)
    @spot.favorites.find_by(end_user_id: current_end_user.id)
    favorite.save
    @spot.create_notification_favorite(current_end_user) unless current_end_user.id == @spot.end_user_id
  end

  def destroy
    @spot = Spot.find(params[:spot_id])
    favorite = current_end_user.favorites.find_by(spot_id: @spot.id)
    favorite.destroy
  end
  
  private
  
  def ensure_guest_user
    end_user = current_end_user
    if end_user.email == "guest@example.com"
      redirect_to request.referer, notice: 'ゲストはいいねできません'
    end
  end
end
