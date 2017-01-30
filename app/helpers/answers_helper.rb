module AnswersHelper
  def link_to_delete_answer(question, answer)
    return unless user_signed_in? && current_user.author_of?(answer)
    link_to 'Delete answer', question_answer_path(question, answer), method: :delete, remote: true
  end

  def link_to_edit_answer_with_form(question, answer)
    return unless user_signed_in? && current_user.author_of?(answer)
    render 'answers/formedit', question: question, answer: answer
  end

  def link_to_set_best_answer(question, answer)
    return unless user_signed_in? && current_user.author_of?(question) && question.best_answer != answer
    link_to 'Set best', question_answer_set_best_answer_path(question, answer), method: :post, remote: true
  end
end
