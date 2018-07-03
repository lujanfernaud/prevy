# frozen_string_literal: true

# == Schema Information
#
# Table name: image_placeholders
#
#  id            :bigint(8)        not null, primary key
#  resource_id   :bigint(8)
#  resource_type :string
#  image_base64  :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class ImagePlaceholder < ApplicationRecord
  belongs_to :resource, polymorphic: true
end
