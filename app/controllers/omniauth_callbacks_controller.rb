class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    auth
  end

  def twitter
    auth
  end

  def auth
    @user = User.find_for_oauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    elsif @user.new_record?
      session["devise.omniauth_data"] = { provider: auth.provider, uid: auth.uid.to_s }
      render action: :confirm_email, user: @user
    else
      redirect_to new_user_registration_url
    end

  end
end