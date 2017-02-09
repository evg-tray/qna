class Answer < ApplicationRecord
  include Votable
  include Commentable
  belongs_to :question
  belongs_to :user
  has_one :best_for_question, class_name: 'Question', dependent: :nullify, foreign_key: :best_answer_id
  has_many :attachments, as: :attachable

  validates :body, presence: true, length: {minimum: 20}
  validates :question_id, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  scope :best_first, -> do
    best = joins(:question).where('questions.best_answer_id = answers.id')
    best + joins(:question).where('answers.id != questions.best_answer_id') unless best.empty?
  end
end
