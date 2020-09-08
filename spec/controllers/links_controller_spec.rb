require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:wrong_user) { create(:user) }

  before { login(user) }
  describe 'DELETE #destroy' do
    describe 'for questions' do
      subject { post :destroy, params: { id: question.links.first, format: :js } }

      context "user is question's owner" do
        let!(:question) { create(:question, :with_link, user: user) }

        it { expect { subject }.to change(Link, :count).by(-1) }
      end

      context "user isn't question's owner" do
        let!(:question) { create(:question, :with_link, user: wrong_user) }

        it { expect { subject }.to_not change(Link, :count) }
        it 'redirect to question' do
          subject
          expect(response).to redirect_to question
        end
      end
    end
  end

  describe 'for answers' do
    subject { post :destroy, params: { id: answer.links.first, format: :js } }

    context "user is answer's owner" do
      let!(:answer) { create(:answer, :with_link, user: user) }

      it { expect { subject }.to change(Link, :count).by(-1) }
    end

    context "user isn't answer's owner" do
      let!(:answer) { create(:answer, :with_link, user: wrong_user) }

      it { expect { subject }.to_not change(Link, :count) }
      it 'redirect to question' do
        subject
        expect(response).to redirect_to answer.question
      end
    end
  end
end
