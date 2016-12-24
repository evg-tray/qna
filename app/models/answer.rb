class Answer < ApplicationRecord
  belongs_to :question

  validates :body, presence: true, length: {minimum: 20}
  validates :question_id, presence: true
end
