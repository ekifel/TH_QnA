require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, user: user) }
  let!(:reward) { create(:reward, question: question, answer: answer) }


  describe '#GET index' do
    context 'Authenticate user' do
      before { login(user) }
      before { get :index }

      it { expect(response).to render_template :index }
      it { expect(assigns(:rewards)).to eq([reward]) }
    end

    context 'Unauthenticate user' do
      before { get :index }

      it { expect(response).to redirect_to(new_user_session_path) }
    end
  end
end
