class Event < ApplicationRecord
  belongs_to :organizer, class_name: "User"

  validates :title,       presence: true, length: { in: 4..140 }
  validates :description, presence: true, length: { in: 32..1000 }
  validate  :no_past_date

  private

    def no_past_date
      if start_date.nil?
        errors.add(:start_date, "can't be empty")
      elsif end_date.nil?
        errors.add(:end_date, "can't be empty")
      elsif start_date < Time.zone.now
        errors.add(:start_date, "can't be in the past")
      elsif end_date < start_date
        errors.add(:start_date, "can't be later than end date")
      end
    end
end
