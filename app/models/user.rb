class User < ApplicationRecord
  has_secure_password

  has_many :organized_events, class_name: "Event", foreign_key: "organizer_id"

  has_many :attendances, foreign_key: "attendee_id"
  has_many :attended_events, through: :attendances

  validates :name,  presence: true, length: { in: 3..50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
end
