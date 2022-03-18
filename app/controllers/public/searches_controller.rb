class Public::SearchesController < ApplicationController
  before_action :authenticate_end_user!

  def search
    @content = params[:content]
    if @content[0] == "#"
      @records = Tag.search_for(@content).with_attached_spot_images.order(created_at: :desc).page(params[:page])
    else
      @records = Spot.search_for(@content).with_attached_spot_images.order(created_at: :desc).page(params[:page])
    end

    # 複数検索（未完成）
    # @content = params[:content].split(/[[:blank:]]+/).select(&:present?)

    # tags_keywords = @content.grep(/[#]/)
    # spot_keywords = @content - tags_keywords
    # redirect_to request.referer unless spot_keywords.length < 2
    # search_spots = Spot.search_for(spot_keywords[0]).with_attached_spot_images
    # result_posts = search_spots.map do |spot|
    #   tag_names = spot.tags.pluck(:name)
      
    #   extra_tags = tag_names - tags_keywords
    #   nacessary_tags = tag_names - extra_tags
    #   search_tags = nacessary_tags + tags_keywords
      
    #   spot if (search_tags - tags_keywords).empty?
    # end.compact

    # @records = Kaminari.paginate_array(result_posts).page(params[:page]).per(8)


    # tags = search_tags.map do |tag|
    #   Tag.search_for(tag).with_attached_spot_images
    # end.flatten
    # spots = search_spots.map do |spot|
    #   Spot.search_for(spot).with_attached_spot_images
    # end.flatten

   # Spot.spot_tag_search_for(search_tags, search_spots)

  end
end
