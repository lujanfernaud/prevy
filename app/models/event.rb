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

  before_save :check_website_url

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

    attributes.reject(&:blank?).map(&:strip).join(", ")
  end

  def short_address
    return unless address

    attributes = [place_name, city]

    attributes.reject(&:blank?).map(&:strip).join(", ")
  end

  def latitude
    address.latitude if address
  end

  def longitude
    address.longitude if address
  end

  def start_date_prettyfied
    happens_this_year? ? start_date_formatted : start_date_formatted_with_year
  end

  def end_date_prettyfied
    happens_this_year? ? end_date_formatted : end_date_formatted_with_year
  end

  private

    def no_past_date
      if start_date < Time.zone.now
        errors.add(:start_date, "can't be in the past")
      elsif end_date < start_date
        errors.add(:start_date, "can't be later than end date")
      end
    end

    def happens_this_year?
      start_date.year == Time.zone.now.year
    end

    def start_date_formatted
      start_date.strftime("%A, %b. %d, %H:%M")
    end

    def start_date_formatted_with_year
      start_date.strftime("%A, %b. %d, %Y, %H:%M")
    end

    def end_date_formatted
      if same_day?
        end_date.strftime("%H:%M")
      else
        end_date.strftime("%A, %b. %d, %H:%M")
      end
    end

    def end_date_formatted_with_year
      if same_day?
        end_date.strftime("%H:%M")
      else
        end_date.strftime("%A, %b. %d, %Y, %H:%M")
      end
    end

    def same_day?
      start_date.strftime("%A, %b. %d") == end_date.strftime("%A, %b. %d")
    end

    def check_website_url
      return if url_has_protocol?

      self.website = "https://" + website
    end

    def url_has_protocol?
      website =~ /https?\:\/\//
    end
end
