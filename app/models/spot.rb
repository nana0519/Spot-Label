class Spot < ApplicationRecord
  belongs_to :end_user
  has_many :tag_maps, dependent: :destroy
  has_many :tags, through: :tag_maps
  has_many :favorites, dependent: :destroy
  
  has_many_attached :spot_images
  
  validate :spot_images_length
  
  def favorited_by?(end_user)
    favorites.exists?(end_user_id:end_user.id)
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
  
  private
  # 投稿画像枚数の制限
  def spot_images_length
    if spot_images.length >= 5
      errors.add(:base, "画像は5枚以内にしてください")
    end
  end
  
end
