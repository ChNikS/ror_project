require_relative 'acceptance_helper'

feature 'User sign in through social network account', '
  In order to be able to use all functions
  as an user
  i want to able to sign in through social network account
' do
  
    
  scenario 'tries sign in via twitter' do
    visit new_user_session_path
    Rails.application.env_config["omniauth.auth"] = mock_auth_hash_without_email('twitter')
    click_on('Sign in with Twitter')

    expect(page).to have_content 'Please confirm your email address after continue.'
    fill_in 'Email', with: 'test@test.com' 
    click_on('Confirm')

    expect(page).to have_content 'Successfully authenticated from Twitter account.'
    expect(current_path).to eq root_path
  end

  scenario 'tries sign in via facebook' do
    visit new_user_session_path
    Rails.application.env_config["omniauth.auth"] = mock_auth_hash('facebook')
    click_on('Sign in with Facebook')

    expect(page).to have_content 'Successfully authenticated from Facebook account.'
    expect(current_path).to eq root_path
  end

end