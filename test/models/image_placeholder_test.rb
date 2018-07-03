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

require 'test_helper'

class ImagePlaceholderTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
