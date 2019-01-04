class Review < ApplicationRecord
  # add an association that has 1-to-many relationship
  has_many :comments
  # add an association that has 1-to-many relationship
  has_many :bookmarks

  #add an association to user
  belongs_to :user

  #from geocoder gems
  geocoded_by :address
  after_validation :geocode

  #add the photo uploader
  mount_uploader :photo, PhotoUploader


  #adding some validations
  validates :title, presence: true
  validates :body, length: {minimum: 10}
  validates :score, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 10}
  validates :restaurant, presence: true
  #adding validation for our address, part of geocoder
  validates :address, presence: true

  #changing the to_prarams default, take the ID and change it to string (SEO title friendly url)
  def to_param
    id.to_s + "-" + title.parameterize
  end
end
