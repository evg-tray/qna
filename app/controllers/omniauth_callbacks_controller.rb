class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :load_user

  def facebook
    sign_in_provider if @user
  end

  def twitter
    sign_in_provider if @user
  end

  private

  def load_user
    @user = User.from_omniauth(auth)
  end

  def sign_in_provider
    if @user.email_verified?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    else
      render 'omnitokens/register_email'
    end
  end

  def auth
    @auth ||= request.env['omniauth.auth']
  end
end