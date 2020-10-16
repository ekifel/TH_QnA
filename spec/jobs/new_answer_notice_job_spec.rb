require 'rails_helper'

RSpec.describe NewAnswerNoticeJob, type: :job do
  let(:service) { double('Services::NewAnswerNotice') }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:foreign_users) { create_list(:user, 2) }

  it 'calls Services::DailyDigest#send_notice(answer)' do
    allow(Services::NewAnswerNotice).to receive(:new).and_return(service)

    expect(service).to receive(:send_notice).with(answer)
    NewAnswerNoticeJob.perform_now(answer)
  end

  it 'job is created' do
    question.subscriptions.delete_all
    allow(Services::NewAnswerNotice).to receive(:new).and_return(service)

    expect do
      described_class.perform_later(answer)
    end.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :count).by(1)
  end
end
