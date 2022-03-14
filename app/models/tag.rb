class Tag < ApplicationRecord
  has_many :tag_maps, dependent: :destroy
  has_many :spots, through: :tag_maps

  def self.search_for(content)
    tag = Tag.where("name LIKE ?", "%" + content + "%")
    # whereメソッドにより配列になるため、[0]と記述
    tag[0].spots
  end

end
