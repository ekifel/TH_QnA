require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:service) { double('DailyDigestService') }
  let(:users) { create_list(:user, 3) }
  before do
    allow(DailyDigestService).to receive(:new).and_return(service)
  end

  it 'calls Services::DailyDigest#send_digest' do
    expect(service).to receive(:send_digest)
    DailyDigestJob.perform_now
  end

  it 'job is created' do
    ActiveJob::Base.queue_adapter = :test
    expect do
      described_class.perform_later
    end.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end
end
