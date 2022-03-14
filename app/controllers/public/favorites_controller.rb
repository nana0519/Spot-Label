class Public::FavoritesController < ApplicationController
  before_action :authenticate_end_user!
  
  def create
    @spot = Spot.find(params[:spot_id])
    favorite = current_end_user.favorites.new(spot_id: @spot.id)
    favorite.save
  end
  
  def destroy
    @spot = Spot.find(params[:spot_id])
    favorite = current_end_user.favorites.find_by(spot_id: @spot.id)
    favorite.destroy
  end
  
end
