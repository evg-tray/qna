module UserOmniAuth
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def from_omniauth(auth)
      authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
      return authorization.user if authorization

      user = find_or_create_user(auth)
      user.authorizations.create(provider: auth.provider, uid: auth.uid)

      user
    end

    private

    def find_or_create_user(auth)
      email = auth.dig(:info, :email)
      email ||= "temp-#{auth.uid}@temp.com"

      user = User.where(email: email).first
      unless user
        password = Devise.friendly_token[0, 20]
        user = User.create!(email: email, password: password, password_confirmation: password)
      end
      user
    end
  end

  module InstanceMethods
    TEMPORARY_EMAIL_REGEX = /\Atemp-(.*)@temp.com\z/

    def email_verified?
      self.email !~ TEMPORARY_EMAIL_REGEX
    end

    def has_token?(auth)
      authorization = self.authorizations.where(provider: auth.provider, uid: auth.uid.to_s).first
      token = Omnitoken.find_by(user_id: self.id, authorization_id: authorization.id)
      ! token.nil?
    end
  end
end