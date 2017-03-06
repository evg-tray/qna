require_relative '../acceptance_helper'

feature 'Search', %q{
  In order to find question, answer, comment, user
  As a user
  I want to be able to search these
} do

  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:user) { create(:user) }
  given!(:comment_question) { create(:comment, commentable: question) }
  given!(:comment_answer) { create(:comment, commentable: answer) }
  given!(:questions) { create_list(:question, 10, body: 'text text text text text text text') }

  before do
    index
    visit search_path
  end

  scenario 'search question', sphinx: true do
    fill_in 'Text', with: question.title
    check 'scope_0'
    click_on 'Search'
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'search answer', sphinx: true do
    fill_in 'Text', with: answer.body
    check 'scope_1'
    click_on 'Search'
    expect(page).to have_content question.title
    expect(page).to have_content answer.body
  end

  scenario 'search comment to question', sphinx: true do
    fill_in 'Text', with: comment_question.body
    check 'scope_2'
    click_on 'Search'
    expect(page).to have_content question.title
    expect(page).to have_content comment_question.body
  end

  scenario 'search comment to answer', sphinx: true do
    fill_in 'Text', with: comment_answer.body
    check 'scope_2'
    click_on 'Search'
    expect(page).to have_content question.title
    expect(page).to have_content answer.body
    expect(page).to have_content comment_answer.body
  end

  scenario 'search user', sphinx: true do
    fill_in 'Text', with: user.email
    check 'scope_3'
    click_on 'Search'
    expect(page).to have_content user.email
  end

  scenario 'search all', sphinx: true do
    fill_in 'Text', with: user.email
    check 'scope_0'
    check 'scope_1'
    check 'scope_2'
    check 'scope_3'
    click_on 'Search'
    expect(page).to have_content user.email
  end

  scenario 'search without results', sphinx: true do
    fill_in 'Text', with: 'some text'
    check 'scope_0'
    check 'scope_1'
    check 'scope_2'
    check 'scope_3'
    click_on 'Search'
    expect(page).to have_content 'No matches'
  end

  scenario 'pagination', sphinx: true do
    fill_in 'Text', with: 'text'
    check 'scope_0'
    check 'scope_1'
    check 'scope_2'
    check 'scope_3'
    click_on 'Search'
    within '.results' do
      expect(page).to have_selector('p', count: 5)
    end
  end
end
