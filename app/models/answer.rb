class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: {minimum: 20}
  validates :question_id, presence: true
end
