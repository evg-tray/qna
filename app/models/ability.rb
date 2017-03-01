class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Subscription]
    can :update, [Question, Answer], user: user
    can :destroy, [Question, Answer, Vote, Subscription], user: user

    can :destroy, Attachment do |attachment|
      attachment.attachable.user == user
    end

    can :create, Vote do |vote|
      vote.votable.user != user
    end

    can :set_best_answer, Answer do |answer|
      answer.question.user == user && answer.question.best_answer != answer
    end

    can :me, User
  end
end
