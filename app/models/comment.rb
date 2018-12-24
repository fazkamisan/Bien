class Comment < ApplicationRecord
  belongs_to :review
  # adding validation for the body no empty comments
  validates :body, presence: true
end
