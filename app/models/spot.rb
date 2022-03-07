class Spot < ApplicationRecord
  belongs_to :end_user
  has_many :tag_maps, dependent: :destroy
  has_many :tags, through: :tag_maps
  
  has_many_attached :spot_images
  
  def save_tags(tag_list)
    tag_list.each do |tag|
      new_tag = Tag.find_or_create_by(name: tag)
      self.tags << new_tag
    end
  end
end
