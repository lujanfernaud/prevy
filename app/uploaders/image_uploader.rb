# frozen_string_literal: true

class ImageUploader < CarrierWave::Uploader::Base

  include CarrierWave::SampleImage::DefaultFolder

  STANDARD_SIZE = [730, 411]
  MEDIUM_SIZE   = [510, 287]
  THUMB_SIZE    = [350, 197]

  if Rails.env.production?

    include Cloudinary::CarrierWave

    def public_id
      "#{application_name}/#{model_type}/#{original_file_name}"
    end

    process eager: true
    process resize_to_fill: STANDARD_SIZE
    cloudinary_transformation quality: "auto"

    version :medium do
      process eager: true
      process resize_to_fill: MEDIUM_SIZE
      cloudinary_transformation quality: "auto"
    end

    version :thumb do
      process eager: true
      process resize_to_fill: THUMB_SIZE
      cloudinary_transformation quality: "auto"
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

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  private

    def application_name
      Rails.application.class.parent_name.underscore
    end

    def model_type
      model.class.to_s.underscore.pluralize
    end

    def original_file_name
      Cloudinary::PreloadedFile.split_format(original_filename).first
    end

end
