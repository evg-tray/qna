require_relative '../acceptance_helper'

feature 'Create answer', %q{
  In order to help find solution on question
  As user
  I want to be able create answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user creates answer', js: true do
    sign_in(user)
    visit question_path(question)
    answer_text = Faker::Lorem.characters(50)
    fill_in 'Body', with: answer_text
    click_on 'Create answer'

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    within '.answers' do
      expect(page).to have_content answer_text
    end
  end

  scenario 'Authenticated user tries create answer with invalid body', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'Body', with: '333'
    click_on 'Create answer'

    expect(page).not_to have_content '333'

  end

  scenario 'Non-authenticated user tries create answer' do
    visit question_path(question)

    expect(page).not_to have_selector('#answer_body')
  end

end