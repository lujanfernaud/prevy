class Address < ApplicationRecord
  belongs_to :event

  validates :street1,   presence: true
  validates :city,      presence: true
  validates :post_code, presence: true
  validates :country,   presence: true
end
