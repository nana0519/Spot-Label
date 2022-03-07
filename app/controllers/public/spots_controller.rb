class Public::SpotsController < ApplicationController
  def new
    @spot = Spot.new
  end

  def create
    @spot = Spot.new(spot_params)
    @spot.end_user_id = current_end_user.id
    if @spot.save
      tag_list = params[:spot][:tag_ids].split(/[[:blank:]]+/).select(&:present?)
      @spot.save_tags(tag_list)
      redirect_to mypage_end_users_path
    else
      render "new"
    end
  end



  private

  def spot_params
    params.require(:spot).permit(:introduction, :address, spot_images: [], tag_ids: [])
  end

end
