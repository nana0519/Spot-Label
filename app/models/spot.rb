class Spot < ApplicationRecord
  belongs_to :end_user
  has_many :tag_maps, dependent: :destroy
  has_many :tags, through: :tag_maps
  has_many :favorites, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many_attached :spot_images

  validate :file_length
  validates :address, presence: true

  def favorited_by?(favorites, end_user_id)
    favorites.pluck(:end_user_id).include?(end_user_id)
  end

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

  def self.search_for(content)
    Spot.where("address LIKE ?", "%" + content + "%")
  end
  
  def spot_tag_search_for(content)
    Spot.includes(:tags).where("address LIKE ?", "%" + content + "%").where("name LIKE ?", "%" + content + "%")
  end

  # 投稿画像枚数の制限
  def file_length
    if spot_images.length > 5 || spot_images.length < 1
      errors.add(:spot_images, "は1枚以上、5枚未満にしてください")
    end
  end
end
