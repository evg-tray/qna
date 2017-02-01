require_relative '../acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an author of answer
  I want to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario 'Author add file when create answer', js: true do
    sign_in(user)

    visit question_path(question)
    fill_in 'Body', with: Faker::Lorem.characters(50)
    attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create answer'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
    end
  end

  scenario 'Author add few files when create answer', js: true do
    sign_in(user)

    visit question_path(question)
    fill_in 'Body', with: Faker::Lorem.characters(50)
    click_on 'Add file'
    inputs = all('input[type="file"]')
    inputs[0].set("#{Rails.root}/spec/spec_helper.rb")
    inputs[1].set("#{Rails.root}/spec/spec_helper.rb")

    click_on 'Create answer'

    within '.answers' do
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/1/spec_helper.rb'
      expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/2/spec_helper.rb'
    end
  end
end