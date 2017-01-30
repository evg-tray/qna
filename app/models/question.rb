class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  belongs_to :best_answer, class_name: 'Answer', optional: true
  has_many :attachments, as: :attachable

  validates :title, presence: true, length: {minimum: 10, maximum: 200}
  validates :body, presence: true, length: {minimum: 20}

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  def set_best_answer(answer)
    self.update(best_answer: answer) if self.answers.find(answer.id)
  end
end
