class ImageUploader < CarrierWave::Uploader::Base

  STANDARD_SIZE = [730, 411]
  MEDIUM_SIZE   = [510, 287]
  THUMB_SIZE    = [350, 197]

  if Rails.env.production?

    include Cloudinary::CarrierWave

    def public_id
      "private_events/#{model_class}/#{model_id}/#{original_file_name}"
    end

    process eager: true
    process resize_to_fill: STANDARD_SIZE

    version :medium do
      process eager: true
      process resize_to_fill: MEDIUM_SIZE
    end

    version :thumb do
      process eager: true
      process resize_to_fill: THUMB_SIZE
    end

  else

    include CarrierWave::MiniMagick

    process resize_to_fill: STANDARD_SIZE

    version :medium do
      process resize_to_fill: MEDIUM_SIZE
    end

    version :thumb do
      process resize_to_fill: THUMB_SIZE
    end

  end

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
