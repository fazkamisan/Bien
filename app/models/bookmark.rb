class Bookmark < ApplicationRecord
  belongs_to :review
  belongs_to :user
  #making it unique per user per review by adding scope { scope: [type of model]}
  validates :review, uniqueness: {scope: :user}
end
