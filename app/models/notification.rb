class Notification < ApplicationRecord
  belongs_to :user

  validates :message, presence: true

  def link
    {}
  end
end
