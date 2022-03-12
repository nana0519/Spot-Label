class Public::SearchesController < ApplicationController

  def search
    @content = params[:content]
    if @content[0] == "#"
      @records = Tag.search_for(@content).order(created_at: :desc).page(params[:page])
    else
      @records = Spot.search_for(@content).order(created_at: :desc).page(params[:page])
    end
  end

end
