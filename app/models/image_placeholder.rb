class ImagePlaceholder < ApplicationRecord
  belongs_to :resource, polymorphic: true
end
