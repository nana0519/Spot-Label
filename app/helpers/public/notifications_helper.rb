module Public::NotificationsHelper
  def notification_form(notification)
    visitor = link_to notification.visitor.name, end_user_path(notification.visitor)
    @comment = nil
    your_post = link_to "投稿", notification.spot
    # actionの種類（favorite,comment,follow）
    case notification.action
      when "follow" then
        "#{visitor}があなたをフォローしました"
      when "favorite" then
       "#{visitor}が#{your_post}にいいね！しました"
      when "comment" then
        @comment = Comment.find_by(id: notification.comment_id)&.comment
        "#{visitor}が#{your_post}にコメントしました"
    end
  end
  
  # 未確認通知を知らせる
  def unchecked_notification
    @notifications = current_end_user.passive_notifications.where(checked: false)
  end
end
