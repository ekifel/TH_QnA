require 'sphinx_helper'

RSpec.describe SphinxSearchService do
  let(:question) { create(:question) }

  subject { SphinxSearchService.new(q: question.title, section: 'all') }

  it 'Search by request', js: true, sphinx: true do
    expect(ThinkingSphinx).to receive(:search).with(question.title).and_call_original
    subject.call
  end

  it 'return right data', js: true, sphinx: true do
    ThinkingSphinx::Test.run do
      expect(ThinkingSphinx.search(question.title)).to eq(subject.call)
    end
  end
end
