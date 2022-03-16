class Public::SpotsController < ApplicationController
  before_action :authenticate_end_user!
  before_action :ensure_guest_user, only: [:new, :edit]

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
    @spots = Spot.with_attached_spot_images.includes(:favorites, :end_user).order(created_at: :desc).page(params[:page])
    @current_end_user = current_end_user
  end

  def show
    @spot = Spot.with_attached_spot_images.find(params[:id])
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
  
  def ensure_guest_user
    end_user = current_end_user
    if end_user.email == "guest@example.com"
      redirect_to spots_path, notice: 'ゲストはアクセスできません'
    end
  end
end