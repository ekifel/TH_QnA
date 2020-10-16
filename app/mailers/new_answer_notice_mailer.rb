class NewAnswerNoticeMailer < ApplicationMailer
  def notice_for_user(user, answer)
    @question = answer.question.title
    @answer = answer.body
    @greeting = "Good Day, #{user.email}!"

    mail(to: user.email, subject: "Hey, it's new answer to #{@question}")
  end

  def notice_for_owner(user, answer)
    @question = answer.question.title
    @answer = answer.body
    @greeting = "Good Day, #{user.email}!"

    mail(to: user.email, subject: "Hey, you got a new answer to #{@question}!")
  end
end
