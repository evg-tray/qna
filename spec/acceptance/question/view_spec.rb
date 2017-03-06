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

  scenario 'Best answer is a first in list answers' do
    user = create(:user)
    question = create(:question, user: user)
    answers = create_list(:answer, 3, question: question)
    question.set_best_answer(answers[0])
    visit question_path(question)

    expect(page.find('.answers .panel.panel-default:first-child')).to have_content answers[0].body

    question.set_best_answer(answers[1])
    visit question_path(question)

    expect(page.find('.answers .panel.panel-default:first-child')).to have_content answers[1].body
  end
end
