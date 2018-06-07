class Notification < ApplicationRecord
  belongs_to :user

  validates :message, presence: true

  def link
    {}
  end

  def redirecter_path(**params)
    Rails.application
         .routes
         .url_helpers
         .user_notification_redirecter_path(
           user,
           { notification: self }.merge(params)
         )
  end
end
