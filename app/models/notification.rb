class Notification < ApplicationRecord
  belongs_to :user

  validates :message, presence: true

  def link
    {}
  end

  def redirecter_path(**params)
    NotificationRedirecter.path(self, **params)
  end
end
