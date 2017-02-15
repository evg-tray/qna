class OmnitokensController < ApplicationController

  def register_email
    @user = User.find_by(id: params[:user_id])
    @auth = Authorization.find_by(uid: params[:auth_uid], provider: params[:auth_provider])
    Omnitoken.create!(user: @user, authorization: @auth, email: params[:email], token: Devise.friendly_token)
  end

  def verify_email
    token = Omnitoken.find_by(token: params[:token])
    user = User.find_by(email: token.email)
    Omnitoken.transaction do
      if user
        token.authorization.update(user: user)
        tokenuser = token.user
      else
        token.user.update(email: token.email)
      end
      token.destroy
      tokenuser.destroy if tokenuser
    end
    flash[:notice] = 'Your account updated.'
    redirect_to root_path
  end
end