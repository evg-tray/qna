require_relative '../acceptance_helper'

feature 'Edit question', %q{
  In order to fix mistake
  As an author of question
  I want to be able edit my question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user tries edit question' do
    visit question_path(question)

    within '.question' do
      expect(page).not_to have_link 'Edit'
    end
  end

  scenario 'Author tries edit his question', js: true do
    sign_in(user)
    visit question_path(question)

    updated_title = Faker::Lorem.characters(25)
    updated_body = Faker::Lorem.characters(55)
    within '.question' do
      click_on 'Edit'

      expect(page).not_to have_content 'Edit'

      fill_in 'Title', with: updated_title
      fill_in 'Body', with: updated_body
      click_on 'Save'
      expect(page).to have_content 'Edit'
      expect(page).not_to have_content 'textfield'
      expect(page).not_to have_content 'textarea'
      expect(page).to have_content updated_title
      expect(page).to have_content updated_body
    end
  end

  scenario 'Authenticated user tries edit other user answer' do
    user2 = create(:user)
    sign_in(user2)
    visit question_path(question)

    within '.question' do
      expect(page).not_to have_content 'Edit'
    end
  end
end