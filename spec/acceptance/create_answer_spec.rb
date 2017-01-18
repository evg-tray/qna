feature 'Create answer', %q{
  In order to help find solution on question
  As user
  I want to be able create answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user creates answer' do
    sign_in(user)
    visit question_path(question)
    answer_text = Faker::Lorem.characters(50)
    fill_in 'Body', with: answer_text
    click_on 'Create answer'

    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    expect(page).to have_content answer_text
  end

  scenario 'Non-authenticated user tries create answer' do
    visit question_path(question)

    expect(page).not_to have_selector('#answer_body')
  end

end