require_relative '../acceptance_helper'

feature 'Set best answer', %q{
  In order to set a best answer
  As author of question
  I want to be able to set best answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Non-authenticated user try to choose best answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Set best'
  end

  scenario 'Authenticated user set best answer to his question', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Set best'

    expect(page).to have_content 'Best answer:'
  end

  scenario 'Authenticated user tries set best answer for not his question' do
    user2 = create(:user)
    sign_in(user2)
    visit question_path(question)

    expect(page).to_not have_link 'Set best'
  end
end