class Public::CommentsController < ApplicationController
  
  def create
    @spot = Spot.find(params[:spot_id])
    comment = current_end_user.comments.new(comment_params)
    comment.spot_id = @spot.id
    comment.save
  end
  
  def destroy
    Comment.find(params[:id]).destroy
    @spot = Spot.find(params[:spot_id])
  end
  
  private
  def comment_params
    params.require(:comment).permit(:comment)
  end
  
end
