class NewAnswerNoticeJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Services::NewAnswerNotice.new.send_notice(answer)
  end
end
