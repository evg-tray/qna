require_relative '../acceptance_helper'

feature 'View questions', %q{
  In order to be able to read questions
  As an any user
  I want to be able view questions
} do

  scenario 'Any user view questions' do
    questions = create_list(:question, 2)
    visit questions_path

    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[1].title
  end

  scenario 'Any user view question and answers' do
    questions = create_list(:question, 2, :with_answers)
    visit questions_path
    click_on questions[0].title

    expect(page).to have_content questions[0].title
    expect(page).to have_content questions[0].body
    expect(page).to have_content questions[0].answers[0].body
    expect(page).to have_content questions[0].answers[1].body
  end
end