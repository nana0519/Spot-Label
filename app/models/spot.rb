class Spot < ApplicationRecord
  belongs_to :end_user
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  # タグ機能
  has_many :tag_maps, dependent: :destroy
  has_many :tags, through: :tag_maps

  has_many_attached :spot_images

  # 住所から緯度経度を取得する
  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  validate :file_length
  validates :address, presence: true

  # いいねしているか確認
  def favorited_by?(favorites, end_user_id)
    favorites.pluck(:end_user_id).include?(end_user_id)
  end

  # タグの作成
  def save_tags(save_tag_lists)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - save_tag_lists
    new_tags = save_tag_lists - current_tags

    old_tags.each do |old_name|
      old_tag = self.tags.find_by(name: old_name)
      self.tags.delete(old_tag)
    end

    new_tags.each do |new_name|
      new_tag = Tag.find_or_create_by(name: new_name)
      self.tags << new_tag
    end
  end

  # 検索機能（住所＋タグ）
  def self.search_for(spot_keywords, tags_keywords)
    spot_keywords.each_with_index do |pref, i|
      if i == 0
        @res = Spot.where("address like ?", "%#{pref}%")
      else
        @res = @res.or(Spot.where("address like ?", "%#{pref}%"))
      end
    end

    ids = TagMap.joins(:tag).where(tag: { name: tags_keywords }).group(:spot_id).
      count("spot_id").map { |k, v| k if v == tags_keywords.count }.compact
    # Active StorageのN+1問題
    @res = @res.where(id: ids).with_attached_spot_images.order(created_at: :desc)
    @res.distinct
  end

  # 検索機能（住所のみ）
  def self.search_for_only_address(spot_keywords)
    spot_keywords.map do |spot_keyword|
      # Active StorageのN+1問題
      Spot.where("address LIKE ?", "%" + spot_keyword + "%").with_attached_spot_images.order(created_at: :desc)
    end.flatten
  end

  # いいねの通知
  def create_notification_favorite(current_end_user)
    temp = Notification.where([
      "visitor_id = ? and visited_id = ? and spot_id = ? and action = ?",
      current_end_user.id,
      end_user.id,
      id,
      "favorite"
      ])
      
    if temp.blank?
      notification = current_end_user.active_notifications.new(
        spot_id: id,
        visited_id: end_user_id,
        action: "favorite"
      )
      # 自分の投稿に対するいいねは通知しない
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  # コメントの通知
  def create_notification_comment(current_end_user, comment_id)
    notification = current_end_user.active_notifications.new(
      spot_id: id,
      comment_id: comment_id,
      visited_id: end_user_id,
      action: "comment"
    )

    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

  # 投稿画像枚数の制限
  def file_length
    if spot_images.length > 5 || spot_images.length < 1
      errors.add(:spot_images, "は1枚以上、5枚未満にしてください")
    end
  end
end
