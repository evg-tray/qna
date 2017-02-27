require_relative '../acceptance_helper'

feature 'Subscribe to questions', %q{
  In order to be able to receive notifications of new answers
  As an authenticated user
  I want to be able to subscribe to question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'non authenticated user tries subscribe/unsubsribe question' do
    visit question_path(question)

    expect(page).not_to have_link 'Subscribe'
    expect(page).not_to have_link 'Unsubscribe'
  end

  scenario 'author of question', js: true do
    sign_in(user)
    visit question_path(question)

    expect(page).to have_link 'Unsubscribe'
    expect(page).not_to have_link 'Subscribe'

    click_on 'Unsubscribe'

    expect(page).not_to have_link 'Unsubscribe'
    expect(page).to have_link 'Subscribe'
  end

  scenario 'non author of question', js: true do
    user2 = create(:user)
    sign_in(user2)
    visit question_path(question)

    expect(page).not_to have_link 'Unsubscribe'
    expect(page).to have_link 'Subscribe'

    click_on 'Subscribe'

    expect(page).to have_link 'Unsubscribe'
    expect(page).not_to have_link 'Subscribe'
  end
end