require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:wrong_user) { create(:user) }

  describe 'GET #index' do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end

    it 'assings a new Link to answer' do
      expect(assigns(:answer).links.first).to be_a_new(Link)
    end
  end

  describe 'GET #new' do
    before { login(user) }
    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end

    it 'assings a new Link to question' do
      expect(assigns(:question).links.first).to be_a_new(Link)
    end
  end

  describe 'POST #create' do
    before { login(user) }

    subject { post :create, params: { question: question_params } }

    context 'with valid attributes' do
      let(:question_params) { attributes_for(:question) }

      it 'saves a new question in the database' do
        expect { subject }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        subject
        expect(response).to redirect_to assigns(:question)
      end

      it 'made by current user' do
        subject
        expect(assigns(:question).user).to eq user
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) } }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'user created this question' do
      before { login(user) }

      context 'with valid attributes' do
        it 'assigns the requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question), format: :js }

          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
          question.reload

          expect(question.title).to eq 'new title'
          expect(question.body).to eq 'new body'
        end

        it 'redirect to update question' do
          patch :update, params: { id: question, question: attributes_for(:question) }, format: :js

          expect(response).to redirect_to question
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

        it 'does not change question' do
          question.reload

          expect(question.title).to eq 'MyString'
          expect(question.body).to eq 'MyText'
        end

        it 're-renders edit view' do
          expect(response).to render_template :update
        end
      end
    end

    context 'user who did not create this question' do
      before { login(wrong_user) }

      before { patch :update, params: { id: question, question: question_params }, format: :js }

      context 'with attributes' do
        let(:question_params) { { title: 'new title', body: 'new body' } }

        it 'can not change question' do
          expect(question.reload.body).to_not eq 'new title'
          expect(question.reload.body).to_not eq 'new body'
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'current user asked this question' do
      before { login(user) }

      let!(:question) { create(:question, user: user) }

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'current user not asked this question' do
      before { login(wrong_user) }

      let!(:question) { create(:question, user: user) }

      it 'no deletes the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirect to question' do
        delete :destroy, params: { id: question }

        expect(response).to redirect_to question_path(question)
      end
    end
  end

  include_examples 'rated_actions', :question
  include_examples 'commented_actions', :question
end
