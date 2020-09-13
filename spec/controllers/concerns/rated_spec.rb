require 'rails_helper'

shared_examples 'rated_actions' do |rateable_name|
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  describe 'PATCH #rate_up' do
    shared_examples 'correct result' do
      it { expect(response.body).to eq({ id: rateable, type: rateable, rating: 1 }.to_json) }
    end

    shared_examples 'correct no result' do
      it { expect(response.body).to eq({ id: rateable, type: rateable, rating: 0 }.to_json) }
    end

    context 'user is rateable owner' do
      before { login(user) }
      let!(:rateable) { create(rateable_name, user: user) }

      before { patch :rate_up, params: { id: rateable, format: :json } }

      include_examples 'correct no result'
    end

    context 'user is not rateable owner' do
      before { login(user) }
      let!(:rateable) { create(rateable_name) }

      before { patch :rate_up, params: { id: rateable, format: :json } }

      include_examples 'correct result'
    end
  end

  describe 'PATCH #rate_down' do
    shared_examples 'correct result' do
      it { expect(response.body).to eq({ id: rateable, type: rateable, rating: -1 }.to_json) }
    end

    shared_examples 'correct no result' do
      it { expect(response.body).to eq({ id: rateable, type: rateable, rating: 0 }.to_json) }
    end

    context 'user is rateable owner' do
      before { login(user) }
      let!(:rateable) { create(rateable_name, user: user) }

      before { patch :rate_down, params: { id: rateable, format: :json } }

      include_examples 'correct no result'
    end

    context 'user is not rateable owner' do
      before { login(user) }
      let!(:rateable) { create(rateable_name) }

      before { patch :rate_down, params: { id: rateable, format: :json } }

      include_examples 'correct result'
    end
  end

  describe 'DELETE #cancel_vote' do
    shared_examples 'correct result' do
      it { expect(response.body).to eq({ id: rateable, type: rateable, rating: 0 }.to_json) }
    end

    context 'user is not rateable owner' do
      before { login(user) }
      let!(:rateable) { create(rateable_name) }
      let!(:rate) { create(:rate, rateable: rateable, user: user, status: 1) }

      before { patch :cancel_vote, params: { id: rateable, format: :json } }

      include_examples 'correct result'
    end
  end
end
