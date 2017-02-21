class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :is_best
  has_many :comments, serializer: CommentSerializer
  has_many :attachments, serializer: AttachmentSerializer

  def is_best
    object.question.best_answer == object
  end
end
