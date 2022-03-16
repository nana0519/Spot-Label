class Public::CommentsController < ApplicationController
  before_action :authenticate_end_user!
  before_action :ensure_guest_user, only: [:create, :destroy]

  def create
    @spot = Spot.find(params[:spot_id])
    @comment = current_end_user.comments.new(comment_params)
    @comment.spot_id = @spot.id
    unless @comment.save
      render "error"
    end
  end

  def destroy
    Comment.find(params[:id]).destroy
    @spot = Spot.find(params[:spot_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end

  def ensure_guest_user
    end_user = current_end_user
    if end_user.email == "guest@example.com"
     redirect_to request.referer
    end
  end
end
