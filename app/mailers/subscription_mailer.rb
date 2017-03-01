class SubscriptionMailer < ApplicationMailer

  def notify(user, answer)
    @answer = answer
    @question = @answer.question
    mail(to: user.email, subject: "New answer to #{@question.title}")
  end
end
