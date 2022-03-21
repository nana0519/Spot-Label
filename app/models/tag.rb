class Tag < ApplicationRecord
  has_many :tag_maps, dependent: :destroy
  has_many :spots, through: :tag_maps
  
  validate :tag_names_check

  def self.search_for(content)
    content.map do |content|
      tag = Tag.where(name: content)
       tag.present? ? tag[0].spots.order(created_at: :desc) : tag = []
    end.flatten
  end
  
  # バリデーションに引っかかって失敗したら
  # 失敗した情報が入ったtagモデルが返ってくる
  # 成功したら trueが返ってくる
  def self.list_check(tag_list)
    if (tag_list == [])
      tmp_tag = Tag.new(name: "")
      tmp_tag.valid?
      return tmp_tag
    end
    
    tag_list.each do |current_tag|
      tag_model = Tag.new(name: current_tag)
      check_result = tag_model.valid?
      
      if (check_result == false)
        return tag_model
      end
    end
    
    return true
  end
  
  private
  
  def tag_names_check
    #byebug
    errors.add(:name, "の前に半角#をつけてください") unless name.include?("#") == true
  end
end
