class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, presence: true, length: {minimum: 10, maximum: 200}
  validates :body, presence: true, length: {minimum: 20}
end
