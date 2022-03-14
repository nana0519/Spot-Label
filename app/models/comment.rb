class Comment < ApplicationRecord
  belongs_to :end_user
  belongs_to :spot
  
  validates :comment, presence: true
end
