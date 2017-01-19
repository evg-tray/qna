module AnswersHelper
  def link_to_delete_answer(question, answer)
    return unless user_signed_in?
    return unless current_user.author_of?(answer)
    link_to 'Delete answer', question_answer_path(question, answer), method: :delete
  end
end
