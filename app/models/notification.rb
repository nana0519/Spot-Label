class Notification < ApplicationRecord
  belongs_to :spot, optional: true
  belongs_to :comment, optional: true
  belongs_to :visitor, class_name: "EndUser", foreign_key: "visitor_id", optional: true
  belongs_to :visited, class_name: "EndUser", foreign_key: "visited_id", optional: true
end
