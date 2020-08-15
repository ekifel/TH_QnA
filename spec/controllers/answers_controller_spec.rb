require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:wrong_user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question, user: user) }

  describe 'GET #edit' do
    before { login(user) }

    before { get :edit, params: { question_id: question, id: answer } }

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { login(user) }

    subject { post :create, params: { question_id: question, user_id: user, answer: answer_params } }

    context 'with valid attributes' do
      let(:answer_params) { attributes_for(:answer) }

      it 'saves a new answer in the database' do
        expect { subject }.to change(Answer, :count).by(1)
      end

      it "redirect to answer's question view" do
        subject
        expect(response).to redirect_to question_path(question)
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
        expect(response).to render_template 'questions/show'
      end
    end
  end

  describe 'PATCH #update' do
    context 'answer was made by current user' do
      before { login(user) }

      before { patch :update, params: { question_id: question, user_id: user, id: answer, answer: answer_params } }

      context 'with valid attributes' do
        let(:answer_params) { { body: 'new body' } }

        it 'assigns the requested answer to @answer' do
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answer attributes' do
          expect(answer.reload.body).to eq 'new body'
        end

        it "redirect to answer's question" do
          expect(response).to redirect_to question_path(answer.question)
        end
      end

      context 'with invalid attributes' do
        let(:answer_params) { attributes_for(:answer, :invalid) }

        it 'does not change answer' do
          expect(answer.reload.body).to eq answer.body
        end

        it 're-render edit answer view' do
          expect(response).to render_template :edit
        end
      end
    end

    context 'answer was not made by current user' do
      before { login(wrong_user) }

      before { patch :update, params: { question_id: question, user_id: user, id: answer, answer: answer_params } }

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

      subject { delete :destroy, params: { question_id: question, user_id: user, id: answer } }

      it 'deletes the answer' do
        expect { subject }.to change(Answer, :count).by(-1)
      end

      it "redirect to answer's question" do
        subject
        expect(response).to redirect_to question_path(question)
      end
    end

    context 'answer was not made by current user' do
      before { login(wrong_user) }
      let!(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question, user: user) }

      subject { delete :destroy, params: { question_id: question, user_id: user, id: answer } }

      it 'not deletes from database' do
        expect { subject }.to change(Answer, :count).by(0)
      end

      it "redirect to answer's question" do
        subject
        expect(response).to redirect_to question_path(question)
      end
    end
  end
end
