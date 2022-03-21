class Public::TagsController < ApplicationController
  before_action :authenticate_end_user!
  
  def show
    @tag = Tag.find(params[:id])
    @spots = @tag.spots.order(created_at: :desc).page(params[:page])
  end
end
