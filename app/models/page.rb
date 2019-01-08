class Page < ApplicationRecord
  #prevent url from being used twice
  validates :url, uniqueness: true

  #mount image uploader via carrierwave
  mount_uploader :image, ContentForImageUploader

end
