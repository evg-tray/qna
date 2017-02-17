class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    sign_in_provider
  end

  def twitter
    sign_in_provider
  end

  private

  def sign_in_provider
    @user = User.from_omniauth(auth)

    if @user.persisted?
      if @user.email_verified?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
      else
        render 'omnitokens/register_email'
      end
    end
  end

  def auth
    @auth ||= request.env['omniauth.auth']
  end
end