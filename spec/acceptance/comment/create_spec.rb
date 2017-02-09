require_relative '../acceptance_helper'

feature 'Create comment', %q{
  In order to clarify question/answer
  As an authenticated user
  I want to be able comment question/answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  context 'question' do
    scenario 'Authenticated user creates comment', js: true do
      sign_in(user)
      visit question_path(question)
      comment_text = Faker::Lorem.characters(25)
      within '.question .new_comment' do
        fill_in 'Comment', with: comment_text
        click_on 'Create comment'
      end
      within '.question .comments' do
        expect(page).to have_content comment_text
      end
    end

    scenario 'comment to question appears to another user page', js: true do
      comment_text = Faker::Lorem.characters(25)

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('another_user') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question .new_comment' do
          fill_in 'Comment', with: comment_text
          click_on 'Create comment'
        end
      end

      Capybara.using_session('another_user') do
        within '.question .comments' do
          expect(page).to have_content comment_text
        end
      end
    end

    scenario 'Authenticated user tries create comment with invalid body', js: true do
      sign_in(user)
      visit question_path(question)
      within '.question .new_comment' do
        fill_in 'Comment', with: '123'
        click_on 'Create comment'
      end
      within '.question .comments' do
        expect(page).not_to have_content '123'
      end
    end
  end

  context 'answer' do
    scenario 'Authenticated user creates comment', js: true do
      sign_in(user)
      visit question_path(question)
      comment_text = Faker::Lorem.characters(25)
      within ".answer-#{answer.id} .new_comment" do
        fill_in 'Comment', with: comment_text
        click_on 'Create comment'
      end
      within ".answer-#{answer.id} .comments" do
        expect(page).to have_content comment_text
      end
    end

    scenario 'comment to answer appears to another user page', js: true do
      comment_text = Faker::Lorem.characters(25)

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)
      end

      Capybara.using_session('another_user') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within ".answer-#{answer.id} .new_comment" do
          fill_in 'Comment', with: comment_text
          click_on 'Create comment'
        end
      end

      Capybara.using_session('another_user') do
        within ".answer-#{answer.id} .comments" do
          expect(page).to have_content comment_text
        end
      end
    end

    scenario 'Authenticated user tries create comment with invalid body', js: true do
      sign_in(user)
      visit question_path(question)
      within ".answer-#{answer.id} .new_comment" do
        fill_in 'Comment', with: '123'
        click_on 'Create comment'
      end
      within ".answer-#{answer.id} .comments" do
        expect(page).not_to have_content '123'
      end
    end
  end

  scenario 'Non-authenticates user tries comment' do
    visit question_path(question)

    expect(page).not_to have_selector('#comment_body')
  end
end