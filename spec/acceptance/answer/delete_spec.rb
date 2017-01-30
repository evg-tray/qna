require_relative '../acceptance_helper'

feature 'Delete answer', %q{
  In order to be able delete wrong answer
  As user
  I want delete answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user delete his answer', js: true do
    sign_in(user)
    visit question_path(question)
    click_on 'Delete answer'

    expect(page).not_to have_content answer.body
  end

  scenario 'Authenticated user delete another answer' do
    user2 = create(:user)
    sign_in(user2)
    visit question_path(question)

    expect(page).not_to have_content 'Delete answer'
  end

  scenario 'Non-authenticated user tries delete answer' do
    visit question_path(question)

    expect(page).not_to have_content 'Delete answer'
  end
end