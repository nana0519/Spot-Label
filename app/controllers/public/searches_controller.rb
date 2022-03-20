class Public::SearchesController < ApplicationController
  before_action :authenticate_end_user!

  def search
    @content = params[:content].split(/[[:blank:]]+/).select(&:present?)
    tags_keywords = @content.grep(/[#]/)
    spot_keywords = @content - tags_keywords

    if spot_keywords.present?
      result_posts = if tags_keywords.size == 1
                      search_spots = Spot.search_for(spot_keywords, tags_keywords)
                     elsif tags_keywords.size > 1
                      search_spots = Spot.search_for(spot_keywords, tags_keywords)
                      search_spots.select {|search_spot| search_spot.tags.pluck(:name).sort == tags_keywords.sort}.uniq 
                     else
                       Spot.search_for_one(spot_keywords[0])
                     end
      @records = Kaminari.paginate_array(result_posts).page(params[:page]).per(8)

    else
      search_tags = Tag.search_for(tags_keywords)
      result_tags = if tags_keywords.size == 1
                      search_tags
                    else
                      search_tags.select {|search_tags| search_tags.tags.pluck(:name).sort == tags_keywords.sort }
                    end
      @records = Kaminari.paginate_array(result_tags).page(params[:page]).per(8)
    end
    
  end
end
