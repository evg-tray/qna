require_relative '../acceptance_helper'

feature 'Vote questions', %q{
  In order to be able to vote for a good/bad question
  As an authenticated user
  I want to be able to vote question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Non-authenticated user tries vote to question' do
    visit question_path(question)

    expect(page).not_to have_link 'Up'
    expect(page).not_to have_link 'Down'
    expect(page).not_to have_link 'Delete vote'
  end

  scenario 'Author tries vote to question' do
    sign_in(user)
    visit question_path(question)

    expect(page).not_to have_link 'Up'
    expect(page).not_to have_link 'Down'
    expect(page).not_to have_link 'Delete vote'
  end

  scenario 'Non-author votes to question', js: true do
    user2 = create(:user)
    sign_in(user2)
    visit question_path(question)

    expect(page).not_to have_link 'Delete vote'

    click_on 'Up'
    expect(page).to have_link 'Delete vote'
    expect(page).not_to have_link 'Up'
    expect(page).not_to have_link 'Down'
    expect(page).to have_content '1'

    click_on 'Delete vote'
    expect(page).to have_link 'Up'
    expect(page).to have_link 'Down'
    expect(page).not_to have_link 'Delete vote'
    expect(page).to have_content '0'

    click_on 'Down'
    expect(page).to have_link 'Delete vote'
    expect(page).not_to have_link 'Up'
    expect(page).not_to have_link 'Down'
    expect(page).to have_content '-1'
  end
end