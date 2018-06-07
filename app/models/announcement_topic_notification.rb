class AnnouncementTopicNotification < Notification
  belongs_to :group
  belongs_to :topic

  def link
    { text: "Go to announcement", path: notification_redirecter_path }
  end

  private

    def notification_redirecter_path
      redirecter_path(group: group, topic: topic)
    end
end
