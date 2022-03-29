class Tag < ApplicationRecord
  has_many :tag_maps, dependent: :destroy
  has_many :spots, through: :tag_maps

  validate :tag_names_check

  # タグ検索
  def self.search_for(tags_keywords)
    ids = TagMap.joins(:tag).where(tag: { name: tags_keywords }).group(:spot_id).
      count("spot_id").map { |k, v| k if v == tags_keywords.count } .compact
    Spot.where(id: ids).with_attached_spot_images.order(created_at: :desc)
  end

  # バリデーションに引っかかって失敗したら
  # 失敗した情報が入ったtagモデルが返ってくる
  # 成功したら trueが返ってくる
  def self.list_check(tag_list)
    tag_list.each do |current_tag|
      tag_model = Tag.new(name: current_tag)
      check_result = tag_model.valid?

      if check_result == false
        return tag_model
      end
    end
    true
  end

  private

  def tag_names_check
    errors.add(:name, "の前には#をつけてください") unless name.include?("#") == true
  end
end
