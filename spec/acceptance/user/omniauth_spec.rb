require_relative '../acceptance_helper'

feature 'Sign in, sign up OAuth', %q{
  In order to be able to sign in, sign up with accounts from another sites
  As non-authenticated user
  I want to sign in, sign up with these accounts
} do

  context 'facebook' do
    scenario 'sign in when email received from provider' do
      OmniAuth.config.add_mock(:facebook, {uid: '123456', info: {email: Faker::Internet.email}})
      visit new_user_session_path
      click_on 'Sign in with Facebook'

      expect(page).to have_content 'Successfully authenticated from Facebook account.'
      expect(current_path).to eq root_path
    end

    scenario 'sign in when email not received from provider' do
      OmniAuth.config.add_mock(:facebook, {uid: '123456'})
      visit new_user_session_path
      click_on 'Sign in with Facebook'
      email = Faker::Internet.email

      expect(page).to have_content 'Step 2: Need verify your email to continue'

      fill_in 'Email', with: email
      click_on 'Verify'

      expect(page).to have_content 'Check your email!'

      open_email(email)
      current_email.click_link 'Confirm'
      expect(page).to have_content 'Your account updated.'

      visit new_user_session_path
      click_on 'Sign in with Facebook'

      expect(page).to have_content 'Successfully authenticated from Facebook account.'
      expect(current_path).to eq root_path
    end
  end

  context 'twitter' do
    scenario 'sign in when email received from provider' do
      OmniAuth.config.add_mock(:twitter, {uid: '123456', info: {email: Faker::Internet.email}})
      visit new_user_session_path
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Successfully authenticated from Twitter account.'
      expect(current_path).to eq root_path
    end

    scenario 'sign in when email not received from provider' do
      OmniAuth.config.add_mock(:twitter, {uid: '123456'})
      visit new_user_session_path
      click_on 'Sign in with Twitter'
      email = Faker::Internet.email

      expect(page).to have_content 'Step 2: Need verify your email to continue'

      fill_in 'Email', with: email
      click_on 'Verify'

      expect(page).to have_content 'Check your email!'

      open_email(email)
      current_email.click_link 'Confirm'
      expect(page).to have_content 'Your account updated.'

      visit new_user_session_path
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Successfully authenticated from Twitter account.'
      expect(current_path).to eq root_path
    end
  end
end