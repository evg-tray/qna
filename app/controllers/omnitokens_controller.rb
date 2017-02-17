class OmnitokensController < ApplicationController

  skip_authorization_check

  def register_email
    @user = User.find_by(id: params[:user_id])
    @auth = Authorization.find_by(uid: params[:auth_uid], provider: params[:auth_provider])
    Omnitoken.create!(user: @user, authorization: @auth, email: params[:email], token: Devise.friendly_token)
  end

  def verify_email
    result = VerifyEmail.call(token: params[:token])
    flash[:notice] = 'Your account updated.' if result.success?
    redirect_to root_path
  end
end