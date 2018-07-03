# frozen_string_literal: true
# == Schema Information
#
# Table name: image_placeholders
#
#  id            :bigint(8)        not null, primary key
#  image_base64  :text
#  resource_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  resource_id   :bigint(8)
#
# Indexes
#
#  index_image_placeholders_on_resource_id_and_resource_type  (resource_id,resource_type)
#

class ImagePlaceholder < ApplicationRecord
  belongs_to :resource, polymorphic: true
end
