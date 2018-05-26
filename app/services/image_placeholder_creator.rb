# frozen_string_literal: true

class ImagePlaceholderCreator

  def initialize(resource)
    @resource        = resource
    @image_converter = ImageToBase64Converter
    @lqip_generator  = LQIPGenerator
    @image_location  = ""
    @image_base64    = ""
  end

  def call
    return if regular_resource_without_image_updated?

    set_image_location
    create_image_placeholder
  end

  private

    attr_reader :resource, :image_converter, :lqip_generator,
                :image_location, :image_base64

    def regular_resource_without_image_updated?
      !resource.sample_resource? && !resource.saved_changes.include?("image")
    end

    def set_image_location
      @image_location = sample_image_location || regular_image_location
    end

    def sample_image_location
      return unless resource.user_sample_resource?

      resource.sample_image_location
    end

    def regular_image_location
      resource.regular_image_location
    end

    def create_image_placeholder
      generate_lqip
      convert_to_base64
      store_base64_image
    end

    def generate_lqip
      @image_location = lqip_generator.call image_location
    end

    def convert_to_base64
      @image_base64 = image_converter.call image_location
    end

    def store_base64_image
      resource.create_image_placeholder! image_base64: image_base64
    end

end
