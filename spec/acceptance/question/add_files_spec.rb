require_relative '../acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an author of question
  I want to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Author add file when asks question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
  end

  scenario 'Author add few files when asks question', js: true do
    sign_in(user)

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: question.title
    fill_in 'Body', with: question.body
    click_on 'Add file'
    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
    inputs[1].set("#{Rails.root}/spec/spec_helper.rb")

    click_on 'Create'

    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/3/spec_helper.rb'
  end
end