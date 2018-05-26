require 'test_helper'

class ImagePlaceholderCreatorTest < ActiveSupport::TestCase
  BASE64_IMAGE_PATTERN = /data:image\/jpg;base64,\w*/
  ROOT = Rails.root.join("public").to_s
  IMAGE_URL = ROOT + "/images/samples/sample_group.jpg"

  def setup
    stub_geocoder
  end

  test "stores a base64 image for a sample group" do
    group = groups(:sample_group)

    def group.sample_image_location
      IMAGE_URL
    end

    ImagePlaceholderCreator.new(group).call

    assert_match BASE64_IMAGE_PATTERN, group.image_base64
  end

  test "stores a base64 image for a sample event" do
    event = events(:sample_event)

    def event.sample_image_location
      IMAGE_URL
    end

    ImagePlaceholderCreator.new(event).call

    assert_match BASE64_IMAGE_PATTERN, event.image_base64
  end

  test "stores a base64 image for a regular group" do
    group = groups(:one)

    def group.saved_changes
      { "image" => "" }
    end

    def group.regular_image_location
      IMAGE_URL
    end

    ImagePlaceholderCreator.new(group).call

    assert_match BASE64_IMAGE_PATTERN, group.image_base64
  end

  test "stores a base64 image for a regular event" do
    event = events(:one)

    def event.saved_changes
      { "image" => "" }
    end

    def event.regular_image_location
      IMAGE_URL
    end

    ImagePlaceholderCreator.new(event).call

    assert_match BASE64_IMAGE_PATTERN, event.image_base64
  end
end
