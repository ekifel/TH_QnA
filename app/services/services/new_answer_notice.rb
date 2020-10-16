module Services
  class NewAnswerNotice
    def send_notice(answer)
      answer.question.subscribers.find_each do |user|
        if user.is_author?(answer.question)
          unless user.is_author?(answer)
            NewAnswerNoticeMailer.notice_for_owner(user, answer).try(:deliver_later)
          end
        else
          unless user.is_author?(answer)
            NewAnswerNoticeMailer.notice_for_user(user, answer).try(:deliver_later)
          end
        end
      end
    end
  end
end
