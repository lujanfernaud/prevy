# frozen_string_literal: true

# Generates Low Quality Image Placeholders
class LQIPGenerator

  TEMPORARY_FOLDER = Rails.root.join("tmp", "carrierwave", "minimagick")
  FILENAME_PATTERN = /\w*.\w{3}\z/

  def self.call(image_url)
    new(image_url).call
  end

  def initialize(image_url)
    @image_url = image_url
  end

  def call
    prepare_temporary_folder
    generate_lqip
    new_file_full_path
  end

  private

    attr_reader :image_url

    def prepare_temporary_folder
      FileUtils.mkdir_p TEMPORARY_FOLDER
    end

    def generate_lqip
      image = MiniMagick::Image.open(image_url)

      image.resize "30x17"

      image.write new_file_full_path
    end

    def new_file_full_path
      @_new_file_full_path ||= "#{TEMPORARY_FOLDER}/#{new_file_name}"
    end

    def new_file_name
      "#{token}-#{original_file_name}"
    end

    def token
      SecureRandom.urlsafe_base64
    end

    def original_file_name
      image_url.match(FILENAME_PATTERN)[0]
    end
end
