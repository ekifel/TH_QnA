require 'rails_helper'

RSpec.describe Link, type: :model do
  context 'associations' do
    it { should belong_to :linkable }
  end

  context 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :url }
  end

  context 'methods' do
    context 'is_gist?' do
      let!(:gist_link) { create(:link, url: 'https://gist.github.com/ekifel/4a058cb88bf37fba63c4d4513b98de77') }
      let!(:link) { create(:link) }

      it{ expect(gist_link.is_gist?).to be_truthy }
      it{ expect(link.is_gist?).to be_falsey }
    end

    context 'get_gist' do
      let!(:gist_link) { create(:link, url: 'https://gist.github.com/ekifel/4a058cb88bf37fba63c4d4513b98de77') }

      before do
        allow_any_instance_of(Octokit::Client).to receive(:gist).and_return('Files')
      end

      it { expect(gist_link.get_gist).to eq('Files') }
    end
  end
end
