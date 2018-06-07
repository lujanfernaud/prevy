class AnnouncementTopicNotification < Notification
  belongs_to :user
  belongs_to :group
  belongs_to :topic

  def link
    {
      text: "Go to announcement",
      path: notification_redirecter_path_with_params
    }
  end

  private

    def notification_redirecter_path_with_params
      Rails.application.routes.url_helpers
           .user_notification_redirecter_path(
             user,
             notification: self,
             group: group,
             topic: topic
           )
    end
end
