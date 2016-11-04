class UsersController < ApplicationController
  def confirm_email
    auth = session['devise.omniauth_data']
    if auth == nil
      redirect_to new_user_registration_url
    else
      @user = User.generate(user_params)
      @user.create_authorization(auth['provider'], auth['uid'])
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    end
  end

  private
    def user_params
      params.require(:user).permit(:email)
    end
end
