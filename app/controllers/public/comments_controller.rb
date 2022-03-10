class Public::CommentsController < ApplicationController
  
  def create
    spot = Spot.find(params[:spot_id])
    comment = current_end_user.comments.new(comment_params)
    comment.spot_id = spot.id
    comment.save
    redirect_to request.referer
  end
  
  def destroy
    Comment.find(params[:id]).destroy
    redirect_to request.referer
  end
  
  private
  def comment_params
    params.require(:comment).permit(:comment)
  end
  
end
