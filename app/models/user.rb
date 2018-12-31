class User < ApplicationRecord
  #user updating model hook up,  add an association that has 1-to-many relationship
  has_many :reviews
  has_many :comments
  has_many :bookmarks

  # add secure data
  has_secure_password
  # make sure there's field entered and unique
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  # creating the url for user profile, overidding the default
  def to_param
    username
  end
end
