require 'rails_helper'

RSpec.describe NewAnswerNoticeJob, type: :job do
  let(:service) { double('NewAnswerNoticeServes') }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:foreign_users) { create_list(:user, 2) }

  it 'calls DailyDigestService#send_notice(answer)' do
    allow(NewAnswerNoticeService).to receive(:new).and_return(service)

    expect(service).to receive(:send_notice).with(answer)
    NewAnswerNoticeJob.perform_now(answer)
  end

  it 'job is created' do
    question.subscriptions.delete_all
    allow(NewAnswerNoticeService).to receive(:new).and_return(service)

    expect do
      described_class.perform_later(answer)
    end.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :count).by(1)
  end
end
