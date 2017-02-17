class User < ApplicationRecord
  include UserOmniAuth
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
end
