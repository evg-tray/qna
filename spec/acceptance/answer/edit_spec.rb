require_relative '../acceptance_helper'

feature 'Edit answer', %q{
  In order to fix mistake
  As an author of answer
  I want to be able edit my answer
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user tries edit answer' do
    visit question_path(question)

    within ".answer-#{answer.id}" do
      expect(page).not_to have_link 'Edit'
    end
  end

  scenario 'Author tries edit his answer', js: true do
    sign_in(user)
    visit question_path(question)

    updated_text = Faker::Lorem.characters(55)
    within ".answer-#{answer.id}" do
      click_on 'Edit'

      expect(page).not_to have_content 'Edit'

      fill_in 'Body', with: updated_text
      click_on 'Save'
      expect(page).to have_content 'Edit'
      expect(page).not_to have_content 'textarea'
      expect(page).to have_content updated_text
    end
  end

  scenario 'Authenticated user tries edit other user answer' do
    user2 = create(:user)
    sign_in(user2)
    visit question_path(question)

    within ".answer-#{answer.id}" do
      expect(page).not_to have_content 'Edit'
    end
  end
end