class Spot < ApplicationRecord
  belongs_to :end_user
  has_many :tag_maps, dependent: :destroy
  has_many :tags, through: :tag_maps
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  has_many_attached :spot_images
  
  geocoded_by :address
  after_validation :geocode, if: :address_changed?
  
  validate :file_length
  validates :address, presence: true

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
  def self.search_for(content, tags_keywords)
    content.each_with_index do | pref, i |
      if i == 0
        @res = Spot.where("address like ?", "%#{pref}%")
      else
        @res = @res.or(Spot.where("address like ?","%#{pref}%"))
      end
    end
    
    ids = TagMap.joins(:tag).where(tag: {name:tags_keywords}).group(:spot_id).count("spot_id").map{|k,v| k if v==tags_keywords.count }.compact
    @res = @res.where(id: ids).with_attached_spot_images.order(created_at: :desc)
    @res.distinct
  end
  
  # 検索機能（住所のみ）
  def self.search_for_only_address(content)
    content.map do |content|
      Spot.where("address LIKE ?", "%" + content + "%").order(created_at: :desc)
    end.flatten
  end

  # いいねの通知
  def create_notification_favorite(current_end_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and spot_id = ? and action = ? ", current_end_user.id, end_user_id, id, "like"])
    if temp.blank?
    notification = current_end_user.active_notifications.new(
      spot_id: id,
      visited_id: end_user_id,
      action: "favorite"
    )

    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
    end
  end

  # コメントの通知
  def create_notification_comment(current_end_user, comment_id)
    temp_ids = Comment.select(:end_user_id).where(spot_id: id).where.not(end_user_id: current_end_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment(current_end_user, comment_id, temp_id["end_user_id"])
    end
    save_notification_comment(current_end_user, comment_id, end_user_id) if temp_ids.blank?
  end

  def save_notification_comment(current_end_user, comment_id, visited_id)
    notification = current_end_user.active_notifications.new(
      spot_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: "comment"
    )

    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end
  
  # 住所を保存する前に全角のものを半角に変更する
  def text_change
    params[:address].tr("０-９", "0-9").gsub(/(?<=\d)[‐－―ー−](?=\d)/, "-")
  end

  # 投稿画像枚数の制限
  def file_length
    if spot_images.length > 5 || spot_images.length < 1
      errors.add(:spot_images, "は1枚以上、5枚未満にしてください")
    end
  end
end
