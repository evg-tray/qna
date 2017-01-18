feature 'Register user', %q{
  In order to be able to ask question
  As non-authenticated user
  I want to register new user
} do

  scenario 'Register user' do
    visit new_user_session_path
    click_on 'Sign up'
    fill_in 'Email', with: Faker::Internet.unique.email
    pass = Faker::Internet.password
    fill_in 'Password', with: pass
    fill_in 'Password confirmation', with: pass
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

end