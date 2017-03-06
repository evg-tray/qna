module AnswersHelper
  def link_to_delete_answer(question, answer)
    return unless can?(:destroy, answer)
    link_to 'Delete answer', question_answer_path(question, answer), method: :delete, remote: true, class: 'btn btn-danger'
  end

  def link_to_edit_answer_with_form(question, answer)
    return unless can?(:update, answer)
    render 'answers/formedit', question: question, answer: answer
  end

  def link_to_set_best_answer(question, answer)
    return unless can?(:set_best_answer, answer)
    link_to 'Set best', question_answer_set_best_answer_path(question, answer), method: :post, remote: true, class: 'btn btn-info'
  end
end
