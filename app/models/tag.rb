class Tag < ApplicationRecord
  has_many :tag_maps, dependent: :destroy
  has_many :spots, through: :tag_maps

  def self.search_for(content)
    content.map do |content|
      tag = Tag.where(name: content)
       tag.present? ? tag[0].spots.order(created_at: :desc) : tag = []
    end.flatten
  end
end
