require_relative 'acceptance_helper'

feature 'User sign up', %q{
	In order to be able to ask question
	as an user 
	i want to be able to sign up
}  do
  let(:user) { create(:user) }

  scenario 'Registered user try to sign up' do
    visit new_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_button 'Sign up'

    expect(page).to have_content 'Email has already been taken'
    expect(current_path).to eq "/users"
  end

  scenario 'New user try to sign up with valid email & password' do
    visit new_user_registration_path
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_button 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'New user try to sign up with invalid email' do
    visit new_user_registration_path
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_button 'Sign up'
    
    expect(page).to have_content "Email can't be blank"
    expect(current_path).to eq  "/users"#new_user_registration_path
  end

  scenario 'New user try to sign up with invalid password' do
    visit new_user_registration_path
    fill_in 'Email', with: 'test@test.com'
    click_button 'Sign up'

    expect(page).to have_content "Password can't be blank"
    expect(current_path).to eq "/users"#new_user_registration_path
  end
end