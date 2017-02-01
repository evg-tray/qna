require_relative '../acceptance_helper'

feature 'Delete files of answer', %q{
  In order to delete file with error
  As an author of answer
  I want to be able to delete attach file
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Author of answer delete file', js: true do
    sign_in(user)

    visit question_path(question)
    fill_in 'Body', with: Faker::Lorem.characters(50)
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create answer'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
    click_on 'Delete attachment'
    within '.answers' do
      expect(page).not_to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  scenario 'User tries delete file of another author' do
    sign_in(user)
    answer = create(:answer, question: question)
    attachment = create(:attachment, attachable: answer)
    visit question_path(question)
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    expect(page).not_to have_link 'Delete attachment'
  end
end