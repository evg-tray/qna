class VerifyEmail
  include Interactor

  def call
    token = Omnitoken.find_by(token: context.token)
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
  end
end