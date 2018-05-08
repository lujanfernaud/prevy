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
