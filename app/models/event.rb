class Event < ApplicationRecord
  belongs_to :organizer, class_name: "User"
  belongs_to :group

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

  before_save :check_website_url

  scope :past, -> {
    where("end_date < ?", Time.zone.now).order("end_date DESC")
  }

  scope :upcoming, -> {
    where("start_date > ?", Time.zone.now).order("start_date ASC")
  }

  scope :three, -> {
    limit(3)
  }

  mount_uploader :image, ImageUploader

  def latitude
    address.latitude if address
  end

  def longitude
    address.longitude if address
  end

  def very_short_description
    TextShortener.call(text: description, characters: 85)
  end

  def short_description
    TextShortener.call(text: description, characters: 200)
  end

  private

    def no_past_date
      if start_date < Time.zone.now
        errors.add(:start_date, "can't be in the past")
      elsif end_date < start_date
        errors.add(:start_date, "can't be later than end date")
      end
    end

    def check_website_url
      return if url_has_protocol? || website.empty?

      self.website = "https://" + website
    end

    def url_has_protocol?
      website =~ /https?\:\/\//
    end
end
