module QuestionsHelper
  def link_to_delete_question(question)
    return unless can?(:destroy, question)
    link_to 'Delete question', question_path(question), method: :delete
  end

  def link_to_edit_question_with_form(question)
    return unless can?(:update, question)
    render 'questions/formedit', question: question
  end
end
