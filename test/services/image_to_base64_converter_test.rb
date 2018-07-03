# frozen_string_literal: true

require 'test_helper'

class ImageToBase64ConverterTest < ActiveSupport::TestCase
  test "converts an image location to a base64 image" do
    image_location = valid_image_location
    base64_image_pattern = /data:image\/jpg;base64,\w*/

    result = ImageToBase64Converter.call(image_location)

    assert_match base64_image_pattern, result
  end
end
