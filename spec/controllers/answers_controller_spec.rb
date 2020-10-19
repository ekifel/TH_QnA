require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  include ActiveJob::TestHelper

  let(:user) { create(:user) }
  let(:wrong_user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    before { login(user) }

    subject { post :create, params: { question_id: question, answer: answer_params }, format: :js }

    context 'with valid attributes' do
      let(:answer_params) { attributes_for(:answer) }

      it 'saves a new answer in the database' do
        expect { subject }.to change(Answer, :count).by(1)
      end

      it "redirect to answer's question view" do
        subject
        expect(response).to render_template :create
      end

      it 'answer made by current user' do
        subject
        expect(assigns(:answer).user).to eq user
      end
    end

    context 'with invalid attributes' do
      let(:answer_params) { attributes_for(:answer, :invalid) }

      it 'does not save the answer' do
        expect { subject }.to_not change(question.answers, :count)
      end

      it 're-render new answer view' do
        subject
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    context 'answer was made by current user' do
      before { login(user) }

      before { patch :update, params: { question_id: question, id: answer, answer: answer_params }, format: :js }

      context 'with valid attributes' do
        let(:answer_params) { { body: 'new body' } }

        it 'assigns the requested answer to @answer' do
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do
          expect(answer.reload.body).to eq 'new body'
        end

        it "redirect to answer's question" do
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        let(:answer_params) { attributes_for(:answer, :invalid) }

        it 'does not change answer' do
          expect(answer.reload.body).to eq answer.body
        end

        it 're-render edit answer view' do
          expect(response).to render_template "answers/update"
        end
      end
    end

    context 'answer was not made by current user' do
      before { login(wrong_user) }

      before { patch :update, params: { question_id: question, id: answer, answer: answer_params }, format: :js }

      context 'with attributes' do
        let(:answer_params) { { body: 'new body' } }

        it 'no changes in answer attributes' do
          expect(answer.reload.body).to_not eq 'new body'
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'answer was made by current user' do
      before { login(user) }

      let!(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question, user: user) }

      subject { delete :destroy, params: { question_id: question, id: answer }, format: :js }

      it 'deletes the answer' do
        expect { subject }.to change(Answer, :count).by(-1)
      end

      it "redirect to answer's question" do
        subject
        expect(response).to render_template :destroy
      end
    end

    context 'answer was not made by current user' do
      before { login(wrong_user) }

      let!(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question, user: user) }

      subject { delete :destroy, params: { question_id: question, id: answer }, format: :js }

      it 'not deletes from database' do
        expect { subject }.to change(Answer, :count).by(0)
      end

      it "redirect to answer's question" do
        subject
        expect(response).to redirect_to question_path(question)
      end
    end
  end

  describe 'CHOOSE_AS_BEST #patch' do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question) }

    context 'user is question owner' do
      before { login(user) }

      context 'choose best answer first time' do
        before { patch :choose_as_best, params: { id: answer, format: :js } }

        it { expect(response).to render_template :choose_as_best }
        it { expect(question.reload.best_answer).to eq answer }
      end

      context 'choose best answer when it already exist' do
        let!(:best_answer) { create(:answer, question: question, best: true) }

        before { patch :choose_as_best, params: { id: answer, format: :js } }

        it { expect(response).to render_template :choose_as_best }
        it { expect(question.reload.best_answer).to eq answer }
      end
    end

    context 'user is not question owner' do
      before { patch :choose_as_best, params: { id: answer, format: :js } }

      it { expect(question.reload.best_answer).to_not eq answer }
    end
  end

  describe 'Active job notice' do
    before do
      login(user)
      clear_enqueued_jobs
    end

    subject { post :create, params: { question_id: question, answer: answer_params, format: :js } }

    let(:answer_params) { attributes_for(:answer) }

    it 'answer owner subscribed to question' do
      expect { subject }.to change(enqueued_jobs, :count).by(1)
    end

    it 'question subscribers not exists' do
      question.subscriptions.delete_all
      expect { subject }.to change(enqueued_jobs, :count).by(0)
    end

    it 'create correct job' do
      expect { subject }.to have_enqueued_job(NewAnswerNoticeJob)
    end
  end

  include_examples 'rated_actions', :answer
  include_examples 'commented_actions', :answer
end
