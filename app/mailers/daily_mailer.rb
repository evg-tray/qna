class DailyMailer < ApplicationMailer

  def digest(user)
    if @questions = Question.digest
      mail(to: user.email, subject: 'Daily questions digest')
    end
  end
end
