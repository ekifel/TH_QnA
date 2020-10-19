class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.where('created_at > ?', 1.days.ago)
    @greeting  = "Good Day, #{user.email}!"

    mail to: user.email, subject: 'Hey, keep a list of questions from the past day:'
  end
end
