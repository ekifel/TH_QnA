require 'rails_helper'

RSpec.describe NewAnswerNoticeService do
  let!(:user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question, user: user) }

  it 'sends email to all question subscribers' do
    question.subscriptions.first.delete
    question.subscribers.each do |subscriber|
      expect(NewAnswerNoticeMailer).to receive(:notice_for_user).with(subscriber, answer).and_call_original
    end
    subject.send_notice(answer)
  end

  it 'sends email to question owner' do
    question.subscribers.each do |subscriber|
      expect(NewAnswerNoticeMailer).to receive(:notice_for_owner).with(subscriber, answer).and_call_original
    end
    subject.send_notice(answer)
  end
end
