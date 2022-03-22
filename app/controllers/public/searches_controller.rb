class Public::SearchesController < ApplicationController
  before_action :authenticate_end_user!

  def search
    @content = params[:content].tr("＃", "#").split(/[[:blank:]]+/).select(&:present?)
    tags_keywords = @content.grep(/[#]/)
    spot_keywords = @content - tags_keywords

    if spot_keywords.present?
      if tags_keywords.present?
        @records =Spot.search_for(spot_keywords, tags_keywords).page(params[:page]).per(8)
      else
        result_posts = Spot.search_for_only_address(spot_keywords)
        @records =Kaminari.paginate_array(result_posts).page(params[:page]).per(8)
      end

    else
      result_tags =Tag.search_for(tags_keywords)
      @records = Kaminari.paginate_array(result_tags).page(params[:page]).per(8)
    end
  end
end
