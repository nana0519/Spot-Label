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
      redirect_to end_user_path(current_end_user)
    else
      render "new"
    end
  end
  
  def index
    @spots = Spot.order(created_at: :desc).page(params[:page])
  end
  
  def show 
    @spot = Spot.find(params[:id])
    @comment = Comment.new
  end
  
  def edit
    @spot = Spot.find(params[:id])
    @tag_list = @spot.tags.pluck(:name).join(" ")
  end
  
  def update
    @spot = Spot.find(params[:id])
    tag_list = params[:spot][:tag_ids].split(/[[:blank:]]+/).select(&:present?)
    if @spot.update(spot_params)
      @spot.save_tags(tag_list)
      flash[:notice] = "投稿を編集しました"
      redirect_to end_user_path(current_end_user)
    else
      render "edit"
    end
  end
  
  def destroy
    @spot = Spot.find(params[:id])
    @spot.destroy
    redirect_to end_user_path(current_end_user)
  end

  private

  def spot_params
    params.require(:spot).permit(:introduction, :address, spot_images: [], tag_ids: [])
  end

end