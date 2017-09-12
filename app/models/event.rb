class Event < ApplicationRecord
  belongs_to :organizer, class_name: "User"

  has_one :address
  accepts_nested_attributes_for :address, update_only: true

  delegate :place_name, :street1, :street2, :city,
           :state, :post_code, :country, to: :address

  has_many :attendances, foreign_key: "attended_event_id"
  has_many :attendees, through: :attendances

  validates :title,       presence: true, length: { in: 4..140 }
  validates :description, presence: true, length: { in: 32..1000 }
  validates :image,       presence: true
  validate  :no_past_date

  scope :past, -> {
    where("end_date < ?", Time.zone.now).order("end_date DESC")
  }

  scope :upcoming, -> {
    where("start_date > ?", Time.zone.now).order("start_date ASC")
  }

  mount_uploader :image, ImageUploader

  def full_address
    return unless address

    attributes = [place_name, street1, street2, city, state, post_code]

    attributes.reject(&:blank?).join(", ")
  end

  def short_address
    return unless address

    attributes = [place_name, city]

    attributes.reject(&:blank?).join(", ")
  end

  private

    def no_past_date
      if start_date < Time.zone.now
        errors.add(:start_date, "can't be in the past")
      elsif end_date < start_date
        errors.add(:start_date, "can't be later than end date")
      end
    end
end
