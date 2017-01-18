feature 'Delete answer', %q{
  In order to be able delete wrong answer
  As user
  I want delete answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }

  scenario 'Authenticated user delete his answer' do
    sign_in(user)
    answer
    visit question_path(question)
    click_on 'Delete answer'

    expect(page).not_to have_content answer.body
  end

  scenario 'Authenticated user delete another answer' do
    user2 = create(:user)
    sign_in(user2)
    answer
    visit question_path(question)

    expect(page).not_to have_content 'Delete answer'
  end

  scenario 'Non-authenticated user tries delete answer' do
    answer
    visit question_path(question)

    expect(page).not_to have_content 'Delete answer'
  end
end