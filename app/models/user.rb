class User < ApplicationRecord
  has_secure_password

  has_many :organized_events, class_name: "Event", foreign_key: "organizer_id"
end
