class Comment < ApplicationRecord
  belongs_to :review
  belongs_to :user

  # adding validation for the body no empty comments
  validates :body, presence: true

  #implementing profanity filter
  profanity_filter :body
end
