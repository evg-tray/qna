class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, presence: true, length: {minimum: 10, maximum: 200}
  validates :body, presence: true, length: {minimum: 20}

  def set_best_answer(answer)
    self.update(best_answer: answer.id) if answers.find(answer)
  end
end
