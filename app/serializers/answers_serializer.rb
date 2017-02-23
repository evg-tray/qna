class AnswersSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :is_best

  def is_best
    object.question.best_answer == object
  end
end
