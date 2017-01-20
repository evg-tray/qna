module QuestionsHelper
  def link_to_delete_question(question)
    return unless user_signed_in? && current_user.author_of?(question)
    link_to 'Delete question', question_path(question), method: :delete
  end
end