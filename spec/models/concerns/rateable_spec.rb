require 'rails_helper'

shared_examples 'rateable' do
  context 'associations' do
    it { should have_many(:rates).dependent(:destroy) }
  end

  let(:user) { create(:user) }
  let(:another_user) { create(:user) }
  let(:model) { described_class }
  let(:rateable) { create(model.to_s.underscore.to_sym, user: user) }

  describe 'methods' do
    context '#rating' do
      context 'positive rating' do
        let!(:positive_votes) { create_list(:rate, 5, rateable: rateable, user: user, status: 1 ) }
        let!(:negative_votes) { create_list(:rate, 3, rateable: rateable, user: user, status: -1 ) }

        it { expect(rateable.rating).to eq(2) }
      end

      context 'negative rating' do
        let!(:positive_votes) { create_list(:rate, 3, rateable: rateable, user: user, status: 1 ) }
        let!(:negative_votes) { create_list(:rate, 5, rateable: rateable, user: user, status: -1 ) }

        it { expect(rateable.rating).to eq(-2) }
      end
    end

    context '#rate_up' do
      context 'when user is not owner' do
        it { expect { rateable.rate_up(another_user) }.to change(Rate, :count).by(1) }
      end

      context 'when user is owner' do
        it { expect { rateable.rate_up(user) }.to_not change(Rate, :count) }
      end
    end

    context '#rate_down' do
      context 'when user is not owner' do
        it { expect { rateable.rate_down(another_user) }.to change(Rate, :count).by(1) }
      end

      context 'when user is owner' do
        it { expect { rateable.rate_down(user) }.to_not change(Rate, :count) }
      end
    end

    context '#cancel_vote' do
      context 'with positive rate' do
        let!(:rate) { create(:rate, rateable: rateable, user: user, status: 1) }

        it { expect { rateable.cancel_vote(user) }.to change(Rate, :count).by(-1) }
      end

      context 'with negative rate' do
        let!(:rate) { create(:rate, rateable: rateable, user: user, status: -1) }

        it { expect { rateable.cancel_vote(user) }.to change(Rate, :count).by(-1) }
      end
    end
  end
end
