if Rails.env.development? && ENV["skip_cloudinary"]
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end

if Rails.env.test?
  CARRIERWAVE_TEST_ROOT = Rails.root.join("tmp", "carrierwave")
  CARRIERWAVE_TEST_CACHE = Rails.root.join("tmp", "carrierwave", "carrierwave_cache")

  CarrierWave.configure do |config|
    config.root = CARRIERWAVE_TEST_ROOT
    config.cache_dir = CARRIERWAVE_TEST_CACHE
    config.storage = :file
    config.enable_processing = false
  end
end

module CarrierWave
  module MiniMagick

    def quality(percentage)
      manipulate! do |img|
        img.quality(percentage.to_s)
        img = yield(img) if block_given?
        img
      end
    end

  end

  # Sets a default image and returns urls for different versions.
  #
  # - The versions need to be stored manually in the folder specified
  # in the 'default_url' method.
  #
  # - The 'image' field in the resource needs to be left blank.
  #
  # When creating a sample resource for new users, the image field
  # is left blank, validation skipped, and the resource gets to
  # have the image we are setting on 'default_url'.
  module SampleImage

    def samplified_image_url(*args)
      return image_url(*args) unless sample_resource?

      sample_image_url(*args)
    end

    def sample_resource?
      self.send("sample_#{resource}")
    end

    def resource
      self.class.name.parameterize
    end

    def sample_image_url(version = "")
      underscored_version = version.to_s + "_" unless version.empty?

      image_url.gsub("sample_", "#{underscored_version}sample_")
    end

    module DefaultFolder
      # Folder inside '/public'.
      SAMPLE_IMAGES_FOLDER = "/images/samples/"

      def default_url(*args)
        SAMPLE_IMAGES_FOLDER + "sample_#{resource_model}.jpg"
      end

      def resource_model
        self.model.class.name.parameterize
      end
    end

  end
end
