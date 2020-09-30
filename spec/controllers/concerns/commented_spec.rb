require 'rails_helper'

shared_examples 'commented_actions' do |record_name|
  let(:user) { create(:user) }
  let(:another_user) { create(:user) }

  describe 'POST #create_comment' do
    before { login(user) }

    let!(:record) { create(record_name) }

    subject { post :create_comment, params: { id: record, comment: comment_params, format: :js } }

    context 'with valid attributes' do
      let(:comment_params) { attributes_for(:comment) }

      it { expect { subject }.to change(Comment, :count).by(1) }
      it { expect { subject }.to change(record.comments, :count).by(1) }
      it do
        subject
        expect(response).to render_template(:create_comment)
      end
    end

    context 'with invalid attributes' do
      context 'with body empty' do
        let(:comment_params) { attributes_for(:comment, :empty_body) }

        it { expect { subject }.to_not change(Comment, :count) }
        it do
          subject
          expect(response).to render_template(:create_comment)
        end
      end
    end
  end
end
