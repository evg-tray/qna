class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_one :best_answer, class_name: 'Question', dependent: :nullify, foreign_key: :best_answer_id

  validates :body, presence: true, length: {minimum: 20}
  validates :question_id, presence: true

  scope :best_first, -> do
    best = joins(:question).where('questions.best_answer_id = answers.id')
    if best.empty?
      joins(:question)
    else
      best + joins(:question).where('answers.id != questions.best_answer_id')
    end
  end
end
