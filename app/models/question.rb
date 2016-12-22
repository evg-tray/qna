class Question < ApplicationRecord
  has_many :answers

  validates :title, presence: true, length: {minimum: 10, maximum: 200}
  validates :body, presence: true, length: {minimum: 20}
end
