class Public::SearchesController < ApplicationController
  before_action :authenticate_end_user!

  def search
    # @content = params[:content]
    # if @content[0] == "#"
    #   @records = Tag.search_for(@content).with_attached_spot_images.order(created_at: :desc).page(params[:page])
    # else
    #   @records = Spot.search_for(@content).with_attached_spot_images.order(created_at: :desc).page(params[:page])
    # end

    # 複数検索（未完成）
    @content = params[:content].split(/[[:blank:]]+/).select(&:present?)

    tags_keywords = @content.grep(/[#]/)
    spot_keywords = @content - tags_keywords
    redirect_to request.referer unless spot_keywords.length < 2
    search_spots = Spot.joins(:tags).search_for(spot_keywords[0]).where(tags: {name: tags_keywords }).with_attached_spot_images
    result_posts = if tags_keywords.size == 1
                    search_spots
                   elsif tags_keywords.size > 1
                    search_spots.select {|search_spot| search_spot.tags.pluck(:name).sort == tags_keywords.sort}.uniq 
                   else
                     Spot.search_for(spot_keywords[0])
                   end

    @records = Kaminari.paginate_array(result_posts).page(params[:page]).per(8)
  end
end
