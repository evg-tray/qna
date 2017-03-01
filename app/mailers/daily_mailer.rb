class DailyMailer < ApplicationMailer

  def digest(user)
    @questions = Question.digest
    mail(to: user.email, subject: 'Daily questions digest') if @questions
  end
end
