# frozen_string_literal: true

class ImageToBase64Converter

  def self.call(image_location)
    new(image_location).base64_image
  end

  def initialize(image_location)
    @image_location = image_location
  end

  def base64_image
    "data:image/#{image_extension};base64,#{base64_file}"
  end

  private

    attr_reader :image_location

    def image_extension
      image_location.match(/.(\w*\Z)/)[1]
    end

    def base64_file
      Base64.strict_encode64(image_file)
    end

    def image_file
      open(image_location).read
    end

end
