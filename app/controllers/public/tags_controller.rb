class Public::TagsController < ApplicationController
  
  def show
    @tag = Tag.find(params[:id])
    @spots = @tag.spots.order(created_at: :desc).page(params[:page]).per(8)
  end
  
end
