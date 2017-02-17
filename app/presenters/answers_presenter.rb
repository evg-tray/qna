class AnswersPresenter

  def initialize(answer)
    @answer = answer
  end

  def as(presence)
    send("present_as_#{presence}")
  end

  private

  def present_as_publish
    attachments = []
    @answer.attachments.each { |a| attachments << {id: a.id, identifier: a.file.identifier, url: a.file.url} }
    {
        answer: @answer,
        attachments: attachments,
        author_question: @answer.question.user.id,
        question_id: @answer.question_id
    }
  end
end