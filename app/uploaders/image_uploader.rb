class ImageUploader < CarrierWave::Uploader::Base

  def self.test_environment_or_skip_cloudinary?
    Rails.env.test? || ENV["skip_cloudinary"]
  end

  # When including Cloudinary the CarrierWave config doesn't work
  # in the test environment, resulting in the images being uploaded
  # to Cloudinary during tests.
  #
  # The two options that we have to solve this are to use a VCR cassette,
  # or to not include Cloudinary in the test environment.
  #
  # For the time being I decided to go with the second one
  # as it means less code and (I think) needs less maintenance.
  include Cloudinary::CarrierWave unless test_environment_or_skip_cloudinary?

  def public_id
    "private_events/#{model_class}/#{model_id}/#{original_file_name}"
  end

  process eager: true
  process resize_to_fill: [730, 411]

  version :medium do
    process eager: true
    process resize_to_fill: [510, 287]
  end

  version :thumb do
    process eager: true
    process resize_to_fill: [350, 197]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  private

    def model_class
      model.class.to_s.underscore
    end

    # We are uploading the image before the object is created,
    # so it doesn't have an id yet.
    def model_id
      class_last = model.class.last

      return 1 unless class_last

      class_last.id + 1
    end

    def original_file_name
      Cloudinary::PreloadedFile.split_format(original_filename).first
    end

end
