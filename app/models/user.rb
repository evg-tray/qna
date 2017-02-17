class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]
  has_many :questions
  has_many :answers
  has_many :votes
  has_many :authorizations

  def author_of?(post)
    self == post.user
  end

  def voted_of?(post)
    ! post.votes.find_by(user_id: self.id).nil?
  end

  def find_vote(post)
    self.votes.find_by(votable_id: post.id)
  end

  def email_verified?
    self.email !~ /\Atemp-(.*)@temp.com\z/
  end

  def has_token?(auth)
    authorization = self.authorizations.where(provider: auth.provider, uid: auth.uid.to_s).first
    token = Omnitoken.find_by(user_id: self.id, authorization_id: authorization.id)
    ! token.nil?
  end

  def self.from_omniauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = begin
              auth.info[:email]
            rescue
              nil
            end
    email = "temp-#{auth.uid}@temp.com" if email.nil?

    user = User.where(email: email).first
    unless user
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
    end
    user.authorizations.create(provider: auth.provider, uid: auth.uid)

    user
  end
end
