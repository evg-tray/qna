require_relative '../acceptance_helper'

feature 'Delete files of question', %q{
  In order to delete file with error
  As an author of question
  I want to be able to delete attach file
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Author delete file', js: true do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    click_on 'Delete attachment'
    expect(page).not_to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'User tries delete file of another author' do
    sign_in(user)
    attachment = create(:attachment, attachable: question)
    visit question_path(question)
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).not_to have_link 'Delete attachment'
  end
end