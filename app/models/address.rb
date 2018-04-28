class Address < ApplicationRecord
  belongs_to :event

  geocoded_by :full_address
  after_validation :geocode, if: :full_address_changed?

  validates :street1,   presence: true
  validates :city,      presence: true
  validates :post_code, presence: true
  validates :country,   presence: true

  def full_address
    attributes = [place_name, street1, street2, city, state, post_code]

    attributes.reject(&:blank?).map(&:strip).join(", ")
  end

  def full_address_changed?
    !changed.empty?
  end
end
