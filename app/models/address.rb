# == Schema Information
#
# Table name: addresses
#
#  id         :bigint(8)        not null, primary key
#  event_id   :bigint(8)
#  place_name :string
#  street1    :string
#  street2    :string
#  city       :string
#  state      :string
#  post_code  :string
#  country    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  latitude   :float
#  longitude  :float
#

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
