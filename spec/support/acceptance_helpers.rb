module AcceptanceHelper
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in' 
  end
   def mock_auth_hash(provider)
    OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new('provider' => provider,
                                                                        'uid' => '123545',
                                                                        'info' => {
                                                                          'name' => 'user',
                                                                          'email' => 'user@email.com'
                                                                        },
                                                                        'credentials' => {
                                                                          'token' => 'token',
                                                                          'secret' => 'secret'
                                                                        })
  end

  def mock_auth_hash_without_email(provider)
    OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new('provider' => provider,
                                                                        'uid' => '123545',
                                                                        'info' => {
                                                                          'name' => 'user',
                                                                          'email' => nil
                                                                        },
                                                                        'credentials' => {
                                                                          'token' => 'token',
                                                                          'secret' => 'secret'
                                                                        })
  end
end