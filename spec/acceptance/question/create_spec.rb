require_relative '../acceptance_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask question
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Authenticated user creates question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created.'
  end

  scenario 'Authenticated user tries create question with invalid data' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: ''
    fill_in 'Body', with: ''
    click_on 'Create'

    expect(page).to have_content 'Your question is invalid.'
  end

  scenario 'Non-authenticated user tries to creates question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'question appears to another user page', js: true do
    title = Faker::Lorem.characters(30)
    body = Faker::Lorem.characters(55)

    Capybara.using_session('user') do
      sign_in(user)
      visit questions_path
    end

    Capybara.using_session('another_user') do
      visit questions_path
    end

    Capybara.using_session('user') do
      click_on 'Ask question'
      fill_in 'Title', with: title
      fill_in 'Body', with: body
      click_on 'Create'
    end

    Capybara.using_session('another_user') do
      expect(page).to have_content title
    end
  end
end