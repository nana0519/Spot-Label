class Public::SearchesController < ApplicationController
  before_action :authenticate_end_user!

  def search
    # 受け取った検索ワードをTagモデル（タグ）とSpotモデル（住所）に分ける
    @content = params[:content].tr("＃", "#").split(/[[:blank:]]+/).select(&:present?)
    tags_keywords = @content.grep(/[#]/)
    spot_keywords = @content - tags_keywords

    # 検索ワード（住所＋タグ）
    if spot_keywords.present?
      if tags_keywords.present?
        @records = Spot.search_for(spot_keywords, tags_keywords).page(params[:page])

      # 検索ワード（住所のみ）
      else
        result_posts = Spot.search_for_only_address(spot_keywords)
        @records = Kaminari.paginate_array(result_posts).page(params[:page])
      end

    # 検索ワード（タグのみ）
    else
      result_tags = Tag.search_for(tags_keywords)
      @records = Kaminari.paginate_array(result_tags).page(params[:page])
    end
  end
end
