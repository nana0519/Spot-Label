class Public::SpotsController < ApplicationController
  before_action :authenticate_end_user!
  before_action :ensure_guest_user, only: [:new, :edit]

  def new
    @spot = Spot.new
    @tag = Tag.new
  end

  def create
    # 住所の番地の全角を半角へ変換
    address_changed = address_params
    address_changed[:address] = address_changed[:address].tr("０-９", "0-9").gsub(/(?<=\d)[‐－―ー−](?=\d)/, "-")
    
    temp_spot = spot_params.merge(address_changed)
    @spot = Spot.new(temp_spot)
    @spot.end_user_id = current_end_user.id

    # タグをチェックする
    tag_list = params[:spot][:tag_ids].tr("＃", "#").split(/[[:blank:]]+/).select(&:present?)
    @tag = Tag.list_check(tag_list)

    if @tag === true && @spot.save
      @spot.save_tags(tag_list)
      redirect_to end_user_path(current_end_user)
    else
      @spot.valid?
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
    @comments = @spot.comments.order(created_at: :desc).page(params[:page]).per(3)
  end

  def edit
    @spot = Spot.find(params[:id])
    @tag_list = @spot.tags.pluck(:name).join(" ")
    @tag =Tag.new
  end

  def update
    @spot = Spot.find(params[:id])
    tag_list = params[:spot][:tag_ids].tr("＃", "#").split(/[[:blank:]]+/).select(&:present?)
    @tag = Tag.list_check(tag_list)

    if @tag === true && @spot.update(spot_params)
      @spot.save_tags(tag_list)
      flash[:notice] = "投稿を編集しました"
      redirect_to spot_path(@spot)
    else
      @spot.valid?
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
    params.require(:spot).permit(:introduction, spot_images: [], tag_ids: [])
  end
  def address_params
    params.require(:spot).permit(:address)
  end

  def ensure_guest_user
    end_user = current_end_user
    if end_user.email == "guest@example.com"
      redirect_to spots_path, notice: 'ゲストはアクセスできません'
    end
  end
end